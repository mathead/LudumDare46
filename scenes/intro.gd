extends Node2D

var cur = 1

func _input(event):
	if event.is_pressed() and not event.is_echo():
		get_node("part_"+str(cur)).queue_free()
		cur += 1
		if cur <= 4:
			get_node("part_"+str(cur)).visible = true
		else:
			get_tree().change_scene("res://scenes/main.tscn")

