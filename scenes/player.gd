extends KinematicBody2D

signal instrument_change

onready var music_node = get_node("/root/Main/Music")

onready var good_note_effect = preload("res://scenes/good_note_effect.tscn")
onready var bad_note_effect = preload("res://scenes/bad_note_effect.tscn")

var MAX_SPEED = 90
var ACCELERATION = 2000
var motion = Vector2.ZERO

onready var spr = $Sprite
onready var sound_rad = $SoundRadius
onready var change_rad = $ChangeRadius
onready var instrument_rad = $InstrumentRadius
var spr_offset = 0
var hitting = false

var mus_path = "res://sprites/musician/"
var instruments = ["bagpipes","drum","harp","lute","trumpet"]
var spr_frames = []

func take_bagpipes():
	spr_offset = 0
	emit_signal("instrument_change", get_instrument())
	
func take_drum():
	spr_offset = 1
	emit_signal("instrument_change", get_instrument())
	
func take_harp():
	spr_offset = 2
	emit_signal("instrument_change", get_instrument())

func take_lute():
	spr_offset = 3
	emit_signal("instrument_change", get_instrument())

func take_trumpet():
	spr_offset = 4
	emit_signal("instrument_change", get_instrument())

func _on_good_note(precision):
	var effect = good_note_effect.instance()
	effect.position = position
	get_parent().add_child(effect)
	
	for body in sound_rad.get_overlapping_bodies():
		if body.is_in_group("Knights"):
			body.listen_music()

func _on_bad_note():
	var effect = bad_note_effect.instance()
	effect.position = position
	get_parent().add_child(effect)
	music_node.get_node("Shake").shake(0.3,100,0.5)
	for body in sound_rad.get_overlapping_bodies():
		if body.is_in_group("Knights"):
			body.dont_listen()
			
func _ready():
	music_node.connect("bad_note", self, "_on_bad_note")
	music_node.connect("good_note", self, "_on_good_note")
	connect("instrument_change", music_node, "_on_instrument_change")
	
	for instr in instruments:
		spr_frames.append(load(mus_path + instr + "/idle.tres"))
		spr_frames.append(load(mus_path + instr + "/run.tres"))
		spr_frames.append(load(mus_path + instr + "/fight.tres"))
	take_bagpipes()

func _physics_process(delta):
	var axis = _get_input_axis()
	if axis == Vector2.ZERO:
		_apply_friction(0.0001,delta)
	else:
		_apply_movement(axis*ACCELERATION*delta)
	motion = move_and_slide(motion)
	
func _get_input_axis():
	var axis = Vector2.ZERO
	
	var fight = Input.is_action_pressed("ui_fight")
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	
	axis.x = int(right)-int(left)
	axis.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	
	if fight:
		for body in instrument_rad.get_overlapping_bodies():
			print(body.is_in_group("Stands"))
			if body.is_in_group("Stands"):
				body.change_players_instrument(self)
		
		_anim_fight()		
		for body in change_rad.get_overlapping_bodies():
			if body.is_in_group("Knights"):
				match spr_offset:
					0:
						body.take_shield()
					1:
						body.take_sword()
					3:
						body.take_bow()
					4:
						body.take_spear()
	else:
		if axis.length() > 0:
			_anim_walk()
		else:
			_anim_idle()
	
	if right:
		spr.flip_h = true
	if left:
		spr.flip_h = false		
	
	return axis.normalized()

func get_instrument():
	return instruments[spr_offset]

func _apply_friction(amount,delta):
	if motion.length() > amount:
		motion *= pow(amount,delta)
	else:
		motion = Vector2.ZERO

func _apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func _anim_idle():
	_change_anim(0)
	
func _anim_walk():
	_change_anim(1)
	
func _anim_fight():
	_change_anim(2)
	
func _change_anim(offset):	
	var frames = spr_frames[3*spr_offset+offset]
	if spr.frames != frames:
		spr.frames = frames
