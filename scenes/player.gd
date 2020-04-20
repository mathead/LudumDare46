extends KinematicBody2D

var MAX_SPEED = 90
var ACCELERATION = 2000
var motion = Vector2.ZERO

onready var spr = $Sprite
var spr_offset = 0

var mus_path = "res://sprites/musician/"
var spr_frames = []

func _ready():
	for instr in ["bagpipes","drum","harp","lute","trumpet"]:
		spr_frames.append(load(mus_path + instr + "/idle.tres"))
		spr_frames.append(load(mus_path + instr + "/run.tres"))
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
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	
	axis.x = int(right)-int(left)
	axis.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	
	if axis.length() > 0:
		_anim_walk()
	else:
		_anim_idle()
	
	if right:
		spr.flip_h = true
	if left:
		spr.flip_h = false		
	
	return axis.normalized()


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

	
func _anim_fight():
	pass
	
func _anim_idle():
	print("TRYING IDLING")
	_change_anim(0)
	
func _anim_walk():
	print("TRYING WALKING")
	_change_anim(1)
	
func _change_anim(offset):	
	var frames = spr_frames[2*spr_offset+offset]
	if spr.frames != frames:
		print("CAU")
		spr.frames = frames
