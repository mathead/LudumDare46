extends KinematicBody2D

var MAX_SPEED = 90
var ACCELERATION = 2000
var motion = Vector2.ZERO

onready var spr = $Sprite
var spr_offset = 0
var hitting = false

var mus_path = "res://sprites/musician/"
var instruments = ["bagpipes","drum","harp","lute","trumpet"]
var spr_frames = []

func _ready():
	for instr in instruments:
		spr_frames.append(load(mus_path + instr + "/idle.tres"))
		spr_frames.append(load(mus_path + instr + "/run.tres"))
		spr_frames.append(load(mus_path + instr + "/fight.tres"))
	take_bagpipes()

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(0.0001,delta)
	else:
		apply_movement(axis*ACCELERATION*delta)
	motion = move_and_slide(motion)
	
func get_input_axis():
	var axis = Vector2.ZERO
	
	var fight = Input.is_action_pressed("ui_fight")
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	
	axis.x = int(right)-int(left)
	axis.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	
	if fight:
		_anim_fight()
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

func apply_friction(amount,delta):
	if motion.length() > amount:
		motion *= pow(amount,delta)
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func take_bagpipes():
	spr_offset = 0
	
func take_drum():
	spr_offset = 1
	
func take_harp():
	spr_offset = 2

func take_lute():
	spr_offset = 3

func take_trumpet():
	spr_offset = 4

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
