extends Node2D

var sheet
var step = 0.0
var steps_per_sec = 1
var tolerance = 0.5
var offset_correct_circle = 30
var bad_sound = {
	"a": false,
	"s": false,
	"d": false,
	"f": false,
}

signal bad_note
signal good_note

const NOTE = preload("res://scenes/note.tscn")
const line_length = 12
const keymap = {
	KEY_A: "a",
	KEY_S: "s",
	KEY_D: "d",
	KEY_F: "f",
}

func _ready():
	set_process_input(true)
	load_sheet("a a a . a s d f as ad . . sf . . . a s d f f d s a . . . . asdf asdf asdf asdf")

func _process(delta):
	var last_step = int(step)
	step += steps_per_sec * delta
	for i in range(last_step+line_length, int(step)+line_length):
		create_notes(i)
		
	for key in "asdf":
		if bad_sound[key]:
			get_node("harp"+key).pitch_scale -= delta * (randf() - 0.5) * 5
		
func _input(event):
	if not is_music_press(event):
		return
		
	var letter = keymap[event.scancode]
	get_node(str(letter)).scale = Vector2(1.5,1.5)
	# is bad press?
	if precision() == 0 or \
	  sheet[get_nearest_step()%sheet.size()].find(letter) == -1:
		emit_signal("bad_note")
		play_bad_sound(letter)
		
func play_good_sound(key):
	var sound = get_node("harp"+key)
	sound.pitch_scale = 1
	bad_sound[key] = false
	sound.play()

func play_bad_sound(key):
	var sound = get_node("harp"+key)
	bad_sound[key] = true
	sound.pitch_scale += (randf() - 0.5) / 5
	sound.play()

func is_music_press(event):
	return event is InputEventKey \
		 and not event.is_echo() \
		 and event.is_pressed() \
		 and keymap.has(event.scancode)

func get_nearest_step():
	if step - int(step) < 0.5:
		return int(step)
	return int(step) + 1
		
# returns 0 if bad timing, then 0 to 1 precision score
func precision():
	var rem = abs(get_nearest_step() - step)
	if rem > tolerance:
		return 0 # bad
	return 1 - (rem / tolerance)

func create_notes(step):
	if sheet[step%sheet.size()] == ".":
		return
	
	for n in sheet[step%sheet.size()]:
		var note = NOTE.instance()
		note.music = self
		note.key = n
		note.step = step
		get_node(str(n)+"line").add_child(note)
	
func load_sheet(new_sheet):
	sheet = new_sheet.split(" ")
	for i in range(step, int(step)+line_length):
		create_notes(i)

