extends Area2D
class_name VisionArea


signal player_entered()
signal player_exited()

func _ready():
	body_entered.connect( _on_body_enter )
	body_exited.connect( _on_body_exit )
	
	var p = get_parent()
	if p is Enemy:
		p.dir_changed.connect( _on_direction_changed )
		
		
func _on_body_enter(b: Node2D):
	if b is Player:
		player_entered.emit()
	pass
	
	
func _on_body_exit(b: Node2D):
	if b is Player:
		player_exited.emit()
	pass
	
	
func _on_direction_changed(new_dir: Vector2):
	match new_dir:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
			
	pass
