extends StaticBody2D

onready var spr = $Sprite


var knight_path = "res://sprites/knights/"
var spr_frames = []
var spr_offset = 0
var health = 100
onready var dead_frames = load(knight_path + "/dead.tres")
onready var ear_frames = load(knight_path + "/ears.tres")

func _ready():
	add_to_group("Knights")
	for weapon in ["shield","sword","spear","bow"]:
		spr_frames.append(load(knight_path + weapon + "/idle.tres"))
		spr_frames.append(load(knight_path + weapon + "/fight.tres"))

	take_sword()

func turn_around():
	scale.x *= -1

func take_shield():
	spr_offset = 0
	idle_anim()
	
func take_sword():
	spr_offset = 1
	idle_anim()
	
func take_spear():
	spr_offset = 2
	idle_anim()
	
func take_bow():
	spr_offset = 3
	idle_anim()

func idle_anim():
	_change_anim(0)
	
func fight_anim():
	_change_anim(1)
	
func dead_anim():
	spr.frames = dead_frames
	
func ear_anim():
	spr.frames = ear_frames
	
func heal():
	health += 5

func _change_anim(offset):	
	var frames = spr_frames[2*spr_offset+offset]
	if spr.frames != frames:
		spr.frames = frames

