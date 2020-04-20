extends AnimatedSprite

export var health:int = 3
export var running_speed:float
export(String, "shield","sword","spear","bow") var counter_weapon
export var knockback_amount:float
export var knockback_speed:float
var hit_effect = preload("res://scenes/hit_effect.tscn")

var knock_time = 0
var knockback_multiplier = 5
var state = "running"

func turn_around():
	scale.x *= -1

func knockback():
	state = "knockback"
	add_child(hit_effect.instance())
	health -= 1
	if health <= 0:
		var ef = hit_effect.instance()
		ef.position = position
		get_parent().add_child(ef)
		queue_free()
	knock_time = 0
	
func move_back():
	position.x -= scale.x * 20

func _process(delta):
	match(state):
		"running":
			speed_scale = 1
			position += Vector2(1.0,0)*delta*running_speed*scale.x
			# is in center?
			if abs(position.x - 140) < 40:
				state = "attack_queen"
		"knockback":
			speed_scale = 0
			frame = 0
			knock_time += delta*knockback_speed
			position += Vector2(-3*scale.x,-cos(knock_time))*delta*knockback_amount*knockback_multiplier
			if knock_time > PI:
				state = "running"
		"attack_queen":
			speed_scale = 1
			position += Vector2(scale.x/2, -2) * delta * running_speed
		"killing_queen":
			speed_scale = 1

func _on_Area2D_body_entered(body):
	if body.is_in_group("Knights"):
		if body.get_weapon() == counter_weapon:
			if state != "knockback":
				knockback()
		elif body.get_weapon() == "shield":
			move_back()
		else:
			if body.health >= 0:
				body.hit(10)
				move_back()
	if body.is_in_group("queen"):
		state = "killing_queen"
		Textbox.game_over = true
		Textbox.show_text("The queen is dead. Game over!")

