extends State
class_name LiftState

@export var lift_audio: AudioStream

@onready var carry = $"../CARRY"


func enter():
	player.update_animation( "Lift" )
	player.animation_player.animation_finished.connect( _on_state_complete )
	player.audio.stream = lift_audio
	player.audio.play()

	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> State:
	player.velocity = Vector2.ZERO
	return null
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	return null


func _on_state_complete(_a: String):
	player.animation_player.animation_finished.disconnect( _on_state_complete) 
	state_machine.change_state( carry )
	pass
