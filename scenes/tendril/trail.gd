extends Area2D

var trail_array = [Vector2(), Vector2()]
var normal = Vector2()
var last_pos = Vector2()
#var last_global_pos = Vector2()
var last_line
var rid
var color = Color(1,1,1)
const colora1 = Color(1,1,1,0.4)
const colora2 = Color(1,1,1,0.05)
signal death
var combo = 1

func _ready():
	rid = create_shape_owner(self)
	last_line = SegmentShape2D.new()
	last_line.a = trail_array[0]
	last_line.b = trail_array[1]
	#last_global_pos = global_position
	shape_owner_add_shape(rid, last_line)

func death_pop():
	var next_shape = shape_owner_get_shape_count(rid) - 1
	if next_shape >= 0:
		shape_owner_remove_shape(rid, shape_owner_get_shape_count(rid) - 1)
	
	if len(trail_array) < 2:
		emit_signal("death")
	
	update()

func _draw():
	if len(trail_array) > 2:
		draw_polyline(trail_array, color * colora2, 35, true)
		draw_polyline(trail_array, color * colora1, 25, true)
		draw_polyline(trail_array, color, 15, true)

# rework
func add_line(new_pos):
	var new_normal = (new_pos - trail_array[len(trail_array) - 1]).normalized()
	var distance = last_pos.distance_squared_to(new_pos)
	if distance > 1024: # collision approximation so that there arent tons and tons of line collisions
		if approx_eq(normal, new_normal, 0.01) and distance < 512:
			last_line.b = new_pos
			trail_array[len(trail_array) - 1] = new_pos
		else:
			last_line = SegmentShape2D.new()
			last_line.a = last_pos
			last_line.b = new_pos
			shape_owner_add_shape(rid, last_line)
			last_pos = new_pos
			trail_array.append(new_pos)
		update()
		
		#last_global_pos = global_position + last_pos
		normal = new_normal

static func approx_eq(a, b, v):
	return a.distance_squared_to(b) < v