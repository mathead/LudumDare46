extends StaticBody2D

onready var spr = $Sprite


var knight_path = "res://sprites/knights/"
var spr_frames = []
var spr_offset = 0
var health = 100

func _ready():
	for weapon in ["shield","sword","spear","bow"]:
		spr_frames.append(load(knight_path + weapon + "/idle.tres"))
		spr_frames.append(load(knight_path + weapon + "/fight.tres"))
	take_bow()
	fight_anim()

func turn_around():
	scale.x *= -1

func take_shield():
	spr_offset = 0
	
func take_sword():
	spr_offset = 1
	
func take_spear():
	spr_offset = 2
	
func take_bow():
	spr_offset = 3

func idle_anim():
	_change_anim(0)
	
func fight_anim():
	_change_anim(1)
	
func heal():
	health += 5

func _change_anim(offset):	
	var frames = spr_frames[2*spr_offset+offset]
	if spr.frames != frames:
		spr.frames = frames

