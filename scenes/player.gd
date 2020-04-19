extends KinematicBody2D

var MAX_SPEED = 90
var ACCELERATION = 2000
var motion = Vector2.ZERO

onready var sprites = [$Drum,$Harp,$Lute,$Trumpet,$Bagpipes]

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(0.0001,delta)
	else:
		apply_movement(axis*ACCELERATION*delta)
	motion = move_and_slide(motion)
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
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
	_sprites_invisible()
	sprites[0].show()

func take_harp():
	_sprites_invisible()
	sprites[1].show()

func take_lute():
	_sprites_invisible()
	sprites[2].show()

func take_trumpet():
	_sprites_invisible()
	sprites[3].show()

func take_bagpipes():
	_sprites_invisible()
	sprites[4].show()
