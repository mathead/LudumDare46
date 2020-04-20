extends Node2D

export(PackedScene) var goblin_normal_1
export(PackedScene) var goblin_normal_2
export(PackedScene) var goblin_normal_3
export(PackedScene) var goblin_rider_1
export(PackedScene) var goblin_rider_2
export(PackedScene) var goblin_rider_3
export(PackedScene) var goblin_flyer_1
export(PackedScene) var goblin_flyer_2
export(PackedScene) var goblin_flyer_3
export(PackedScene) var goblin_bomb_1
export(PackedScene) var goblin_bomb_2
export(PackedScene) var goblin_bomb_3

var stands_path = "res://scenes/stands"
onready var stands = [
	load(stands_path+"/stand_harp.tscn"),
	load(stands_path+"/stand_drum.tscn"),
	load(stands_path+"/stand_bagpipes.tscn"),
	load(stands_path+"/stand_lute.tscn"),
	load(stands_path+"/stand_trumpet.tscn"),
]
onready var level_label = $LevelLabel
onready var level_generator = $LevelGenerator
var time = 0
var KNIGHT = preload("res://scenes/knight.tscn")
var width
var height
var difficulty = 1.0
var music_line_height = 32
var spawns = []
var level = 0
var last_level = 0

func _process(delta):
	time += delta
	last_level = level
	level = level_generator.get_level()
	if level > last_level:
		time = 0
	
	var new_spawns = level_generator.get_goblin_spawns(time)
	if not (new_spawns is Array) or new_spawns != []:
		level_label.set_text("Level "+str(level))
		if new_spawns is int:
			generate_stand(new_spawns, height-music_line_height-30)
		elif new_spawns is String:
			Textbox.show_text(new_spawns)
		else:
			for id in new_spawns:
				spawn_goblin(id*3+randi()%3)


func _ready():
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
	randomize()
	
	generate_stand(1, height-music_line_height-30)
	generate_knights(height-music_line_height)
	spawns = generate_goblin_spawns(height-music_line_height)
	
	Textbox.show_text("Help! Beat that drum for my knights to keep me alive!")
	
func generate_goblin_spawns(height):
	var left_side = -40
	var right_side = width+40
		
	var spawns = []
	for side in [left_side,right_side]:
		for y in range(0,height,24):
			spawns.append(Vector2(side,y))
	return spawns
	
func generate_stand(index, height):
	var y = 20
	var stands_num = len(stands)
	y += height/stands_num*(index+1)
	var new_stand = stands[index].instance()
	add_child(new_stand)
	new_stand.position = Vector2(width/2,y)

func spawn_goblin(id):
	var new_goblin
	match(id):
		0:
			new_goblin = goblin_normal_1.instance()
		1:
			new_goblin = goblin_normal_2.instance()
		2:
			new_goblin = goblin_normal_3.instance()
		3:
			new_goblin = goblin_rider_1.instance()
		4:
			new_goblin = goblin_rider_2.instance()
		5:
			new_goblin = goblin_rider_3.instance()
		6:
			new_goblin = goblin_flyer_1.instance()
		7:
			new_goblin = goblin_flyer_2.instance()
		8:
			new_goblin = goblin_flyer_3.instance()
		9:
			new_goblin = goblin_bomb_1.instance()
		10:
			new_goblin = goblin_bomb_2.instance()
		11:
			new_goblin = goblin_bomb_3.instance()
	
	if not new_goblin:
		return
		
	# get free spawn
	var spawn = null
	for i in range(100):
		var bad = false
		var s = spawns[randi()%len(spawns)]
		for child in get_children():
			if "start_spawn" in child and child.start_spawn == s:
				bad = true
				break
		if not bad:
			spawn = s
			break
	if spawn == null:
		spawn = spawns[randi()%len(spawns)]
	
	add_child(new_goblin)
	new_goblin.position = spawn
	new_goblin.start_spawn = spawn
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
