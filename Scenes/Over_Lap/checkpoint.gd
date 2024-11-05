
extends Node2D
class_name CheckPoint

@export var spawnpoint = false
var activate = false

func activated():
	PlayerManager.current_checkpoint = self
	activate = true


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activate:
		activated()
	
