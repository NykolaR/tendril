extends Node2D

var radius = 430
var speed = 1
var score = 0
onready var tree = preload("res://scenes/tree/tree.tscn")

var want_time = 1
var current_time = 1

func _ready():
	pass

func _physics_process(delta):
	current_time = lerp(current_time, want_time, 0.01)
	get_tree().call_group("base", "extend_normal", delta * current_time * speed)
	want_time = min(want_time + (delta * 0.1), 20)
	#want_time = 20

func set_speed(speed):
	current_time = speed

func add_speed(speed):
	current_time += speed
	want_time *= 1.03

func subtract_speed(speed):
	current_time = max(current_time - speed, 0)
	want_time *= 0.97

func spawn_base():
	var node = $trees.get_child(randi() % $trees.get_child_count())
	node.add_base(rand_range(0, PI*2))

func spawn_tree():
	if $trees.get_child_count() >= 10:
		return
	
	var loc = Vector2(radius, 0).rotated(rand_range(0, PI*2))
	
	var new_tree = tree.instance()
	new_tree.position = loc
	
	$trees.add_child(new_tree)
	
	speed += 0.5
	$animation.set_speed_scale(speed)

func end_game():
	if $animation.get_current_animation() == "end_game" and $animation.is_playing():
		return
	
	$animation.set_speed_scale(1)
	$animation.play("end_game")
	get_tree().call_group("base", "set_dying_quiet")

func game_end():
	#send high score to globals
	get_tree().call_group("game_world", "set_score", score)
	queue_free()

func increase_score(amount):
	score += amount
	#print(score)