extends AnimatedSprite

export var health:int
export var running_speed:float
export(int, "shield","sword","spear","bow") var counter_weapon
export var knockback_amount:float

func _ready():
	pass

func _process(delta):
	position.x += delta*running_speed

func _on_Area2D_body_entered(body):
	print(body.get_name())
