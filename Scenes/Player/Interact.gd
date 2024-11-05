extends Area2D


func _ready():
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )
	
func _on_body_entered(body: Node2D):
	if body is GoblinNpc:
		Dialogue.diag_start = true
		
func _on_body_exited(body: Node2D):
	if body is GoblinNpc:
		Dialogue.diag_start = false
