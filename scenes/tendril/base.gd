extends Sprite

#export (Color) var color = Color(1,1,1)
var index = 0
var growth_rate = 1
var alive = false
var dying = false

func _ready():
	index = randi() % len(globals.COLOR_VALUES)
	var color = globals.COLOR_VALUES[index]
	
	$end/end_sprite.self_modulate = color
	$trail.color = color
	$end/particles.self_modulate = color
	$end/particles_explode.self_modulate = color
	
	$trail.normal = position.normalized()
	set_physics_process(false)

func set_normal(normal):
	$trail.normal = normal

func extend_normal(amount):
	if not alive:
		return
	
	if $end == null or $trail == null or $end.is_dragging():
		return
	
	$end.set_physics_process(true)
	$end.new_position = $trail.normal * amount * growth_rate

func set_alive():
	alive = true

func set_dying():
	alive = false
	dying = true
	$end.state = $end.STEADY
	if globals.particles:
		$end/particles.emitting = true
	set_physics_process(true)
	
	#$end/death_sound.play()

func remove_self():
	if $end/death_sound.playing:
		$end/death_sound.connect("finished", self, "queue_free")
	else:
		queue_free()

func set_dying_quiet():
	alive = false
	dying = true
	$end.state = $end.STEADY

func on_death():
	$animation.play("death")
	set_physics_process(false)
	$end/particles.emitting = false

func _physics_process(delta):
	if not dying:
		set_physics_process(false)
		return
	
	$end.position = $trail.trail_array.pop_back()
	$trail.death_pop()