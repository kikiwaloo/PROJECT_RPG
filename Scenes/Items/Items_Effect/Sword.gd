extends ItemsEffect
class_name SwordEffct

@export var audio: AudioStream

func take():
	VariablesWeapons.VARIABLES.sword = true

func use():
	pass
	
