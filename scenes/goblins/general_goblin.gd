extends AnimatedSprite

export var health:int
export var running_speed:float
export(int, "shield","sword","spear","bow") var counter_weapon
export var knockback_amount:float

func _process(delta):
	position += Vector2(1.0,0)*delta*running_speed*scale.x

func _on_Area2D_body_entered(body):
	if body.is_in_group("Knights"):
		queue_free()

func turn_around():
	scale.x *= -1
