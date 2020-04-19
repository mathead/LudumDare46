extends KinematicBody2D

var MAX_SPEED = 90
var ACCELERATION = 2000
var motion = Vector2.ZERO

onready var sprites = [$Drum,$Harp,$Lute,$Trumpet,$Bagpipes]
onready var cur_spr = $Drum

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
	if right:
		cur_spr.flip_h = true
	if left:
		cur_spr.flip_h = false
	axis.x = int(right)-int(left)
	axis.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	return axis.normalized()


func apply_friction(amount,delta):
	if motion.length() > amount:
		motion *= pow(amount,delta)
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func _sprites_invisible():
	for spr in sprites:
		spr.hide()
	
func take_drum():
	_change_spr(0)

func take_harp():
	_change_spr(1)

func take_lute():
	_change_spr(2)

func take_trumpet():
	_change_spr(3)

func take_bagpipes():
	_change_spr(4)
	
func _change_spr(id):
	_sprites_invisible()
	cur_spr = sprites[id]
	sprites[id].show()
