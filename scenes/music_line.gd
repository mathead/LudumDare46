extends Node2D

var sheet
var step = 0.0
var steps_per_sec = 2

const NOTE = preload("res://scenes/note.tscn")
const line_length = 12

func _ready():
	load_sheet("a s d f as ad . . sf . . . a s d f f d s a . . . . asdf asdf asdf asdf")

func _process(delta):
	var last_step = int(step)
	step += steps_per_sec * delta
	for i in range(last_step+line_length, int(step)+line_length):
		create_notes(i)
			
func create_notes(step):
	if sheet[step%sheet.size()] == ".":
		return
	
	for n in sheet[step%sheet.size()]:
		var note = NOTE.instance()
		note.music = self
		note.height = n
		note.step = step
		get_node(str(n)+"line").add_child(note)
	
func load_sheet(new_sheet):
	sheet = new_sheet.split(" ")
	for i in range(step, int(step)+line_length):
		create_notes(i)
