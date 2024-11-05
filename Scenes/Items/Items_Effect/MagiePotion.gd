extends ItemsEffect
class_name MagiePotion


@export var audio: AudioStream


func use():
	LevelManager.set_max_mp( LevelManager.mp + 30 )
	PausedMenu.play_audio( audio )

func take():
	PausedMenu.play_audio( audio )
