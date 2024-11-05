extends Node2D
class_name Stairs


@onready var stair_up = $Stair_Up
@onready var stair_down = $Stair_Down


func _on_area_2d_body_entered(body):
	if body is Player:
		if PlayerManager.player.direction == Vector2.UP:
			stair_up.play()
			var tween = create_tween()
			tween.tween_property(PlayerManager.player, "position", Vector2.UP * 64,1.3).as_relative()
		else:
			var tween = create_tween()
			tween.tween_property(PlayerManager.player, "position", Vector2.DOWN * 64,1.3).as_relative()
			stair_down.play()
