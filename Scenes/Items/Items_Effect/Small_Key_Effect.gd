extends ItemsEffect
class_name SmallKeyEffect


@export var audio: AudioStream

func take():
	LevelManager.set_nb_keys( LevelManager.nb_keys + 1)
	PausedMenu.play_audio( audio )
	if LevelManager.nb_keys >= 1:
		VariablesWeapons.small_key = true
	print(LevelManager.nb_keys)
	
func use():
	LevelManager.set_nb_keys( LevelManager.nb_keys - 1)
	if LevelManager.nb_keys <= 0:
		VariablesWeapons.small_key = false
	pass

