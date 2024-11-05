extends State
class_name DeadState


func init():
	player.player_dead.connect( _on_player_dead )

	
func enter():
	if VariablesWeapons.resurection_potion == true:
		SaveManager.save_game()
	player.animation_player.animation_finished.connect( _on_animation_finished )
	player.update_animation("Dead")

func process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null
	
func _on_player_dead():
	state_machine.change_state(self)
	
func _on_animation_finished(_anim: String):
	await SceneTransition.fade_out()
	get_tree().change_scene_to_file("res://Scenes/Dead_Menu/dead_menu.tscn")
	
