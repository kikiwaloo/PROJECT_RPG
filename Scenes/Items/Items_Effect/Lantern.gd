extends ItemsEffect
class_name LanternEffect

@export var audio: AudioStream

func take():
	VariablesWeapons.VARIABLES.lantern = true
