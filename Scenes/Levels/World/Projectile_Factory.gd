extends Node2D
class_name ProjectileFactory


func _ready():
	PlayerManager.player.projectile_fired.connect( spawn_projectile )
	
	
func spawn_projectile(projectile):
	add_child(projectile)
