extends ItemsEffect
class_name MagieBottle

@export var audio: AudioStream

func take():
	LevelManager.set_max_mp( LevelManager.mp + 15)
	PausedMenu.play_audio( audio )
