extends Node2D

var key
var step
var music

func _ready():
	_process(0)
	set_process_input(true)
	
func _input(event):
	if music.is_music_press(event) \
	  and music.keymap[event.scancode] == key \
	  and music.get_nearest_step() == step \
	  and music.precision() != 0:
		print("good", music.precision())
		music.emit_signal("good_note", music.precision())
		queue_free()

func _process(delta):
	var width = get_parent().texture.get_size().x
	position.x = (float(step) - music.step) / music.line_length * width - width/2
	if position.x < -width / 2 - 10:
		music.emit_signal("bad_note")
		queue_free()
