extends AnimatedSprite

export var health:int
export var running_speed:float

func _ready():
	pass


func _process(delta):
	position.x += delta*running_speed

func _on_Area2D_body_entered(body):
	print(body.get_name())
