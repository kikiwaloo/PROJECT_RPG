extends ItemsEffect
class_name QuarterHeart

@export var audio: AudioStream

func take():
	LevelManager.set_quarter_heart( LevelManager.quarter_heart + 1)
	PausedMenu.play_audio( audio )
	VariablesWeapons.item_pick_up = true
	
func use():
	pass
