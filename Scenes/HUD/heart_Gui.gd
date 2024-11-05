extends Control
class_name HeartGui

@onready var sprite = $Sprite2D

var value: int = 2:
	set( _value):
		value = _value
		update_sprite()

func update_sprite():
	sprite.frame = value
