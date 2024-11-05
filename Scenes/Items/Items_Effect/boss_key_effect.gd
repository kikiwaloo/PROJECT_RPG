extends ItemsEffect
class_name bosskey

@export var audio: AudioStream

func take():
	VariablesWeapons.boss_key = true
	PausedMenu.play_audio( audio )



