extends Node2D

var height
var step
var music

func _process(delta):
	position.x = step - music.step
