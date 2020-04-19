extends Node2D

var knight = preload("res://Knight.tscn")
var width
var height

func _ready():
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	generate_knights()

func generate_knights():
	var left_side = width/4
	var right_side = width/4*3
	
#	for y in range(0,height,24):
#		var left_knight = knight.instance()
#		left_knight.set_position(left_side,y)
#
#		var right_knight = knight.instance()
#		right_knight.set_position(right_side,y)
