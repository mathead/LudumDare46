extends Area2D

onready var stand = get_node("../")

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		stand.change_players_instrument(body)
