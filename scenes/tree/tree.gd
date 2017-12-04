extends Sprite

var radius
var base = preload("res://scenes/tendril/base.tscn")

func _ready():
	radius = texture.get_size().x / 2
	#init_bases()

func init():
	for i in range(4):
		add_base(PI * i / 2)

func add_base(radians):
	if get_child_count() >= 10:
		return
	
	var loc = Vector2(radius, 0).rotated(radians)
	
	var new_base = base.instance()
	new_base.position = loc
	
	add_child(new_base)