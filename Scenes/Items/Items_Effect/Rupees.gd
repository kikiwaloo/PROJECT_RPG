extends ItemsEffect
class_name GreenRupeesEffect

@export var audio: AudioStream
@export var count_rupees: int = 1


func take():
	LevelManager.set_nb_coin( LevelManager.nb_coins + count_rupees )
	PausedMenu.play_audio( audio )

func use():
	pass
