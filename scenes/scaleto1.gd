extends Sprite

func _ready():
	set_process(true)
	
func _process(delta):
	if scale.length() > sqrt(2.0):
		scale *= pow(0.3,delta)
	else:
		scale = Vector2(1.0,1.0)
