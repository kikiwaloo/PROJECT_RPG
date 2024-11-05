extends ItemsEffect
class_name ResurectionPotion


@export var audio: AudioStream

func take():
	VariablesWeapons.resurection_potion = true
	PausedMenu.play_audio( audio )

func use():
	pass
