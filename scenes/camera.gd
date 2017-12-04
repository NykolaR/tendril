extends Camera2D

var locked = false
var moving = false
var current_zoom = 1
var movement = Vector2()

func _process(delta):
	var set = lerp(zoom.x, current_zoom, 0.1)
	zoom = Vector2(set, set)
	movement = movement.linear_interpolate(Vector2(), 0.1)
	if globals.invert_look:
		offset -= movement
	else:
		offset += movement
	
	offset.x = clamp(offset.x, -500 * (1/zoom.x), 500 * (1/zoom.x))
	offset.y = clamp(offset.y, -700 * (1/zoom.y), 700 * (1/zoom.y))

func _input(event):
	if (event is InputEventMouseButton):
		if event.button_index == BUTTON_LEFT and not moving:
			locked = event.pressed
		elif not locked:
			if event.button_index == BUTTON_MIDDLE or event.button_index == BUTTON_RIGHT:
				moving = event.pressed
				if event.pressed:
					movement = Vector2()
			else:
				if event.button_index == BUTTON_WHEEL_DOWN:
					current_zoom = min(1.6, current_zoom + 0.04)
				if event.button_index == BUTTON_WHEEL_UP:
					current_zoom = max(0.4, current_zoom - 0.04)
	
	# for above may want get_viewport().get_mouse_position() in the future
	
	if (event is InputEventMouseMotion):
		if not locked and moving:
			#print("moving")
			movement += event.relative * zoom * globals.mouse_speed * 0.1