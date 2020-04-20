extends Node2D

func _ready():
	$Particles.emitting = true

func _process(delta):
	if not $Particles.emitting:
		queue_free()
