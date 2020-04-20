extends Node2D

func show_text(text):
	$n/Label.text = text
	get_tree().paused = true
	set_process_input(true)
	
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		set_process_input(false)
		get_tree().paused = false
