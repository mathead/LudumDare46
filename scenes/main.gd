extends Node2D

var stands_path = "res://scenes/stands"
onready var stands = [
	load(stands_path+"/stand_harp.tscn"),
	load(stands_path+"/stand_drum.tscn"),
	load(stands_path+"/stand_bagpipes.tscn"),
	load(stands_path+"/stand_lute.tscn"),
	load(stands_path+"/stand_trumpet.tscn"),
]

var knight = preload("res://scenes/knight.tscn")
var width
var height

func _ready():
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	generate_knights()

func generate_knights():
	var left_side = width/4
	var right_side = width/4*3
	var music_line_height = 32
	var usable_height = height-music_line_height
	
	var y = 0
	var stands_num = len(stands)
	for stand in stands:
		y += usable_height/stands_num
		var new_stand = stand.instance()
		add_child(new_stand)
		new_stand.position = Vector2(width/2,y)		
		
	for y in range(0,usable_height,24):
		
		var left_knight = knight.instance()
		add_child(left_knight)
		left_knight.position = Vector2(left_side,y)
		left_knight.take_shield()

		var right_knight = knight.instance()
		add_child(right_knight)
		right_knight.position = Vector2(right_side,y)
		right_knight.take_shield()
		right_knight.turn_around()
