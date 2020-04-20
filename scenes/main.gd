extends Node2D

var stands_path = "res://scenes/stands"
onready var stands = [
	load(stands_path+"/stand_harp.tscn"),
	load(stands_path+"/stand_drum.tscn"),
	load(stands_path+"/stand_bagpipes.tscn"),
	load(stands_path+"/stand_lute.tscn"),
	load(stands_path+"/stand_trumpet.tscn"),
]

var time = 0
var GOBLIN = preload("res://scenes/goblin.tscn")
var KNIGHT = preload("res://scenes/knight.tscn")
var width
var height
var difficulty = 1.0
var music_line_height = 32
var spawns = []

func _process(delta):
	time += delta*(0.5+randf()/2)
	if time > 1.0/difficulty:
		time = 0
		spawn_goblin()
	
func _ready():
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
	randomize()
	
	generate_stands(height-music_line_height-14)
	generate_knights(height-music_line_height)
	spawns = generate_goblin_spawns(height-music_line_height)
	
func generate_goblin_spawns(height):
	var left_side = -40
	var right_side = width+40
		
	var spawns = []
	for side in [left_side,right_side]:
		for y in range(0,height,24):
			spawns.append(Vector2(side,y))
	return spawns
	
func generate_stands(height):
	var y = 0
	var stands_num = len(stands)
	for stand in stands:
		y += height/stands_num
		var new_stand = stand.instance()
		add_child(new_stand)
		new_stand.position = Vector2(width/2,y)

func spawn_goblin():
	var new_goblin = GOBLIN.instance()
	add_child(new_goblin)
	new_goblin.position = spawns[randi()%len(spawns)]
	print(new_goblin.position)
	if new_goblin.position.x > width:
		new_goblin.turn_around()

func generate_knights(height):
	var left_side = width/3
	var right_side = width/3*2
		
	for side in [left_side,right_side]:
		for y in range(0,height,24):
			var new_knight = KNIGHT.instance()
			add_child(new_knight)
			new_knight.position = Vector2(side,y)
			if (side == right_side):
				new_knight.turn_around()
