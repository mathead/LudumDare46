extends StaticBody2D

var sprites = [$Bow,$Shield,$Sword,$Spear]


func turn_around():
	scale.x *= 1

func take_shield():
	_sprites_invisible()
	$Shield.show()
	
func take_sword():
	_sprites_invisible()
	$Shield.show()
	
func take_spear():
	_sprites_invisible()
	$Shield.show()
	
func take_bow():
	_sprites_invisible()
	$Shield.show()

func _sprites_invisible():
	for spr in sprites:
		spr.hide()

	
