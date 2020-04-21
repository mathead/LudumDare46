extends StaticBody2D

onready var spr = $Sprite

const knight_path = "res://sprites/knights/"
var spr_frames = []
var spr_offset = 0
var health = 100
onready var dead_frames = load(knight_path + "/dead.tres")
onready var ear_frames = load(knight_path + "/ears.tres")
var knocked_out = preload("res://sprites/knights/dead.tres")
var hit_effect = preload("res://scenes/hit_effect.tscn")
var weapons = ["shield","sword","spear","bow"]
var listening = true

func _ready():
	add_to_group("Knights")
	for weapon in weapons:
		spr_frames.append(load(knight_path + weapon + "/idle.tres"))
		spr_frames.append(load(knight_path + weapon + "/fight.tres"))
	take_sword()

func turn_around():
	scale.x *= -1

func get_weapon()->String:
	if spr.frames == dead_frames:
		return "dead"
	if spr.frames == ear_frames:
		return "ears"
	return weapons[spr_offset]

func take_shield():
	if health < 0:
		return
	spr_offset = 0
	if listening:
		idle_anim()
	
func take_sword():
	if health < 0:
		return
	spr_offset = 1
	if listening:
		idle_anim()
	
func take_spear():
	if health < 0:
		return
	spr_offset = 2
	if listening:
		idle_anim()
	
func take_bow():
	
	if health < 0:
		return
	spr_offset = 3
	if listening:
		idle_anim()

func dont_listen():
	if health < 0:
		return
	
	if not Textbox.bad_music:
		Textbox.bad_music = true
		Textbox.show_text("I can't listen to this!!! If you play like this, I'll lose my guard.")

	listening = false
	spr.frames = ear_frames
	spr.position.x = +3

func listen_music():
	if health < 0:
		return
	
	listening = true
	idle_anim()

func idle_anim():
	match(spr_offset):
		0:
			spr.position.x = +3
		1:
			spr.position.x = -2
		2:
			spr.position.x = -5
		3:
			spr.position.x = 0
	_change_anim(0)
	
func fight_anim():
	if spr.frames != dead_frames and spr.frames != ear_frames:
		_change_anim(1)
	
func dead_anim():
	spr.frames = dead_frames
	spr.position.x = 0
	
func heal():
	health += 5
	
func hit(damage):
	if listening and not Textbox.shown_shield:
		Textbox.shown_shield = true
		Textbox.show_text("Aaaah! I do not have the correct weapon. Hit me with bagpipes using spacebar to switch to a shield.")
	add_child(hit_effect.instance())
	health -= damage
	if health < 0:
		dead_anim()

func _change_anim(offset):	
	var frames = spr_frames[2*spr_offset+offset]
	if spr.frames != frames:
		spr.frames = frames



func _on_Area2D_area_entered(area):
	if (area.is_in_group("Goblins")):
		if listening:
			fight_anim()


func _on_Area2D_area_exited(area):
	if (area.is_in_group("Goblins")):
		if listening:
			idle_anim()

