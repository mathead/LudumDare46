extends Node

func change_players_instrument(player):
	get_parent().change_players_instrument(player)

func _ready():
	add_to_group("Stands")
