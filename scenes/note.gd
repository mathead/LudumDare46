extends Node2D

var height
var step
var music

func _ready():
	_process(0)

func _process(delta):
	var width = get_parent().texture.get_size().x
	position.x = (float(step) - music.step) / music.line_length * width - width/2
	if position.x < -width / 2 - 10:
		# TODO bad note
		queue_free()
