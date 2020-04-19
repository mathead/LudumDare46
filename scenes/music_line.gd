extends Node2D

var sheet
var step = 0.0
var steps_per_sec = 4

const NOTE = preload("res://scenes/note.tscn")
const line_length = 12

func _ready():
	load_sheet("a s d f as ad . . sf . . . . a s d f")

func _process(delta):
	var last_step = int(step)
	step += steps_per_sec * delta
	for i in range(last_step+line_length, int(step)+line_length):
		create_notes(i%sheet.size())
			
func create_notes(step):
	if sheet[step] == ".":
		return
	
	for n in sheet[step]:
		var note = NOTE.instance()
		note.height = n
		note.step = step
		note.music = self
		get_node(str(n)+"line").add_child(note)
	
func load_sheet(new_sheet):
	sheet = new_sheet.split(" ")
	for i in range(step, int(step)+line_length):
		create_notes(i%sheet.size())
