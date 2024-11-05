extends Area2D
class_name HurtBox

signal did_damage

@export var damage: int = 2

func _ready():
	area_entered.connect( _on_area_entered )
	
func _on_area_entered(area: Area2D):
	if area is HitBox:
		did_damage.emit()
		area.take_damage(self)

