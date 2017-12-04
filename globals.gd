extends Node

enum COLOR_NAMES {RED, GREEN, BLUE, YELLOW, PINK}
const COLOR_VALUES = [Color(1,0.1,0.05), Color(0.1,1,0.05), Color(0.05,0.7,0.9), Color(0.9,0.85,0.05), Color(0.9,0.05,1)]

var mouse_speed = 1
var invert_look = true
var particles = true

func _ready():
	for i in range(5):
		randomize()