extends Node2D

var shown_shield = false
var game_over = false
var bad_music = false

func show_text(text):
	visible = true
	$n/Label.text = text
	get_tree().paused = true
	set_process_input(true)
	
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		visible = false
		set_process_input(false)
		get_tree().paused = false
		if game_over:
			game_over = false
			get_tree().change_scene("res://scenes/main.tscn")
