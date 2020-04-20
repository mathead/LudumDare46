extends Node2D

var sheet
var instrument = "drum"
var step = 0.0
var steps_per_sec = 0.8
var speedup = 0.0005
var offset_correct_circle = 30
var bad_sound = {
	"a": false,
	"s": false,
	"d": false,
	"f": false,
}
var pitch_multiplier = {
	"harp": 1.0,
	"bagpipes": 0.73,
	"trumpet": 0.9,
	"drum": 1.0,
	"lute": 0.8,
}
var speed_multiplier = {
	"harp": 1.0,
	"bagpipes": 1.0,
	"trumpet": 1.0,
	"drum": 3.0,
	"lute": 1.0,
}
var sheets = {
	"harp": ". . . . a s d f as . ad . sf f f f a s d f f d s a . . . . a d s f d s f a ad . sf . af . sd . as . df . f d s a",
	"bagpipes": ". . . . f . f . df d df d sf . df d af . df d f . f . df d df d sf . af . sf . af . s . a . s . a . sdf . adf . sdf d adf d f . f . asdf . asdf . df d df d f . f .",
	"trumpet": ". . . . f . f . f f f f d d d d f d a . f d a . a . f . f d a . f f d d . s . s . . . . f d a .",
	"drum": ". . . . . . . . . a . . . . . . . a . . . . . . . a . . . a . . . a . . . s . . . a . . . s . . . a . s . a . s . a . . . . . . . a . . a . . a . a . . . a . . . a s a s a . . . a . . . a . . . a . . a s . . a . . a s . . . .",
	"lute": ". . . . f . f . af . d d sf . sf . f . f . af d af d f . f . a d a d sf . f . a d a d sf . f ."
}

signal bad_note
signal good_note

const NOTE = preload("res://scenes/note.tscn")
const keymap = {
	KEY_A: "a",
	KEY_S: "s",
	KEY_D: "d",
	KEY_F: "f",
}

func _ready():
	set_process_input(true)
	load_sheet(sheets[instrument])

func _process(delta):
	var last_step = int(step)
	steps_per_sec *= 1 + speedup * delta
	step += steps_per_sec * speed_multiplier[instrument] * delta
	for i in range(last_step+get_line_length(), int(step)+get_line_length()):
#		$tick.volume_db = -20
#		if i % 4 == 0:
#			$tick.volume_db = -10
#		$tick.play()
		create_notes(i)
		
	for key in "asdf":
		if bad_sound[key]:
			get_node(instrument+key).pitch_scale -= delta * (randf() - 0.5) * 5
	# $Music.pitch_scale = steps_per_sec
		
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

func _on_instrument_change(inst):
	instrument = inst
	for key in "asdf":
		for note in get_node(key+"line").get_children():
			note.queue_free()
	load_sheet(sheets[instrument])
#	step -= 1

func get_line_length():
	return 12 * (speed_multiplier[instrument] / 2 + 0.5)
	
func get_tolerance():
	return 0.5 # * speed_multiplier[instrument]

func get_pitch():
	return pitch_multiplier[instrument] * steps_per_sec
		
func play_good_sound(key):
	var sound = get_node(instrument+key)
	sound.pitch_scale = get_pitch()
	bad_sound[key] = false
	sound.play()

func play_bad_sound(key):
	var sound = get_node(instrument+key)
	bad_sound[key] = true
	sound.pitch_scale = get_pitch() + (randf() - 0.5) / 5
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
	if rem > get_tolerance():
		return 0 # bad
	return 1 - (rem / get_tolerance())

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
	for i in range(step, int(step)+get_line_length()):
		create_notes(i)

