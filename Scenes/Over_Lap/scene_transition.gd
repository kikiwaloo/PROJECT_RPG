extends CanvasLayer


@onready var animation_player = $Control/AnimationPlayer


func fade_out()-> bool:
	animation_player.play("Fade_Out")
	await animation_player.animation_finished
	return true
	
func fade_in()-> bool:
	animation_player.play("Fade_In")
	await animation_player.animation_finished
	return true
