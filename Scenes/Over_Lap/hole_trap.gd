extends Area2D
class_name HoleTrap

@export var damage: int = 2

func _ready():
	area_entered.connect( _on_area_entered )
	
func _on_area_entered(area: Area2D):
	if area is FallBox:
		area.take_damage(self)
