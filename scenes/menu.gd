extends Control

var active = true
var options = false
var help = false

signal start_play

func re_activate():
	active = true
	$animation.play("show")

func _on_plays_pressed():
	if $animation.is_playing():
		return
	
	if active:
		active = false
		$animation.play_backwards("show")
		emit_signal("start_play")
		
		sounds.get_node("play").play()


func _on_options_pressed():
	if active:
		if $option_menu/animation.is_playing():
			return
		
		if options:
			$option_menu/animation.play_backwards("show")
			options = false
		else:
			$option_menu/animation.play("show")
			options = true
		
		sounds.get_node("select").play()


func _on_quit_pressed():
	if active:
		get_tree().quit()
		
		#sounds.get_node("select").play()


func _on_invert_camera_toggled( pressed ):
	globals.invert_look = pressed
	sounds.get_node("select").play()


func _on_particles_toggled( pressed ):
	globals.particles = pressed
	sounds.get_node("select").play()


func _on_fullscreen_toggled( pressed ):
	OS.set_window_fullscreen(pressed)
	sounds.get_node("select").play()

func sfx_vol_changed( value ):
	AudioServer.set_bus_volume_db(1, value)



func music_vol_changed( value ):
	AudioServer.set_bus_volume_db(2, value)


func _on_help_pressed():
	if not $help_animation.is_playing():
		if help:
			$help_animation.play_backwards("show")
		else:
			$help_animation.play("show")
		help = not help
		sounds.get_node("select").play()
