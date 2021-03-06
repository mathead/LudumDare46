extends Node2D

var key
var step
var music
var state = "queued"
var anim_left = 1
var dir
var images = [
	preload("res://sprites/notes/note_1.png"),
	preload("res://sprites/notes/note_2.png"),
	preload("res://sprites/notes/note_3.png"),
	preload("res://sprites/notes/note_4.png"),
	]

func _ready():
	$note.set_texture(images[rand_range(0, 4)])
	_process(0)
	set_process_input(true)
	modulate = get_parent().get_color()
	
func _input(event):
	if music.is_music_press(event) \
	  and music.keymap[event.scancode] == key \
	  and music.get_nearest_step() == step \
	  and music.precision() != 0:
		music.emit_signal("good_note", music.precision())
		music.play_good_sound(key)
		state = "good_anim"

func _process(delta):
	match state:
		"queued":
			var width = get_parent().texture.get_size().x
			var offset = music.offset_correct_circle - width/2 
			position.x = (float(step) - music.step) / music.get_line_length() * width + offset
			if position.x < offset - width/music.get_line_length()*music.get_tolerance():
				music.emit_signal("bad_note")
				music.play_bad_sound(key)
				state = "bad_anim"
				dir = Vector2(-30 + randf() * 10, 20 * (randf() - 0.5))
		"good_anim", "bad_anim":
			if anim_left < 0:
				queue_free()
			continue
		"good_anim":
			anim_left -= delta * 2
			var d = pow(anim_left, 6)
			scale = Vector2(2 - d, 2 - d)
			modulate.a = sqrt(anim_left)
		"bad_anim":
			anim_left -= delta
			rotate(-delta * 10)
			scale += Vector2(delta, delta)
			position += dir * delta
