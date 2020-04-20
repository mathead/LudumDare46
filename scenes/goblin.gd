extends AnimatedSprite

export var health = 10.0 
export var running_speed = 20.0
export(int, "shield","sword","spear","bow") var counter_weapon
export var knockback_amount:float


func _process(delta):
	position += Vector2(1.0,0)*delta*running_speed*scale.x

func _on_Area2D_body_entered(body):
	print(body.get_name())

func turn_around():
	scale.x *= -1
