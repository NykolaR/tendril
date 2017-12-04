extends Node2D

enum {STEADY, DRAGGING}
var state = STEADY
#var t_size = Vector2()
var cam
var last_pos = Vector2()

var new_position = Vector2()
var locked
const t_size = Vector2(256, 256) * 0.3 * 0.2

signal dragged

func _ready():
	#t_size = $end_sprite.texture.get_size() * $end_sprite.global_scale
	cam = get_tree().get_nodes_in_group("camera")[0]
	set_process_input(true)
	set_physics_process(false)

func _input(event):
	if not get_parent().alive:
		return
	
	if (event is InputEventMouseButton):
		if event.button_index == BUTTON_MIDDLE or event.button_index == BUTTON_RIGHT:
			locked = event.pressed
		
		if not locked:
			if event.button_index == BUTTON_LEFT:
				if state == STEADY and event.pressed:
					var bounds = Rect2(global_position - (t_size/2.0), t_size)
					if bounds.has_point((get_local_mouse_position() * 0.07) + global_position):
						state = DRAGGING
						if globals.particles:
							$particles.emitting = true
						set_physics_process(true)
				elif state == DRAGGING and not event.pressed:
					state = STEADY
					$particles.emitting = false
					set_physics_process(false)
	
	if (event is InputEventMouseMotion):
		if state == DRAGGING:
			new_position += (event.relative * cam.zoom)

func is_dragging():
	return state == DRAGGING

func _physics_process(delta):
	#var distance = global_position.distance_squared_to(global_position + new_position)
	#if not new_position == Vector2():
	if not new_position == Vector2(): # minor inaccurate collision check because of collision line approximation in trail vs raycast length
		#print("dragged")
		var space_state = get_world_2d().get_direct_space_state()
		#var result = space_state.intersect_ray(get_parent().get_node("trail").get_last_global(), global_position + new_position, [get_parent().get_node("trail")])
		#print(get_parent().get_node("trail").last_pos)
		var result = space_state.intersect_ray(global_position, global_position + new_position, [get_parent().get_node("trail")])
		if not result.empty():
			#print(result.collider.get_parent().index)
			
			if result.collider.get_parent().index == get_parent().index:
				if globals.particles:
					#print("calling")
					$particles_explode.emitting = true
				$death_sound.play()
				get_tree().call_group("game_play", "increase_score", result.collider.combo)
				result.collider.combo += 1
				if randf() > 0.5:
					get_node("../..").add_base(rand_range(0, PI*2))
				else:
					result.collider.get_node("../..").add_base(rand_range(0, PI*2))
				result.collider.get_parent().set_dying()
				get_parent().set_dying()
				get_tree().call_group("game_play", "subtract_speed", 4)
			else:
				$cross_sound.play()
				get_tree().call_group("game_play", "add_speed", 12)
				get_node("../..").add_base(rand_range(0, PI*2))
				result.collider.get_node("../..").add_base(rand_range(0, PI*2))
		global_position += new_position
		new_position = Vector2()
		#set_physics_process(false)
		emit_signal("dragged", position) # add_line call
		#print("moved")
		if abs(global_position.x) > 1000 or abs(global_position.y) > 1000:
			get_tree().call_group("game_play", "end_game")