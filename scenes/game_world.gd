extends Node2D

var high_score = 50
var last_score = 0

onready var game_play = preload("res://scenes/game_play.tscn")

func start_game():
	var new_game = game_play.instance()
	add_child(new_game)

func set_score(score):
	high_score = max(score, high_score)
	last_score = score
	
	$menu/scores/lcont/last.text = str(last_score)
	$menu/scores/hcont/hi.text = str(high_score)
	
	$menu.re_activate()