extends AnimatedSprite

export var health:int
export var running_speed:float
export(String, "shield","sword","spear","bow") var counter_weapon
export var knockback_amount:float
export var knockback_speed:float

var knock_time = 0
var knockback_multiplier = 5
var state = "running"

func turn_around():
	scale.x *= -1

func knockback():
	state = "knockback"
	knock_time = 0

func _process(delta):
	match(state):
		"running":
			speed_scale = 1
			position += Vector2(1.0,0)*delta*running_speed*scale.x
		"knockback":
			speed_scale = 0
			frame = 0
			knock_time += delta*knockback_speed
			position += Vector2(-3*scale.x,-cos(knock_time))*delta*knockback_amount*knockback_multiplier
			if knock_time > PI:
				state = "running"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Knights"):
		if body.get_weapon() == counter_weapon:
			knockback()

