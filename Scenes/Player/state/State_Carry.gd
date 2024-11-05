extends State
class_name  StateCarry

@export var carry_speed: float = 100.0
@export var throw_audio: AudioStream

var walking: bool = false
var throwable: Throwable

@onready var idle = $"../IDLE"
@onready var stunt = $"../STUNT"


func init():
	pass
	
	
func enter()-> void:
	player.update_animation( "Carry" )
	walking = false
	pass
	
func exit()-> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
			
		if state_machine.next_state == stunt:
			throwable.throw_direction = throwable.throw_direction.rotated(PI)
			throwable.drop()
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
			pass
	pass
	
	
func process(_delta: float )-> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation( "Carry" )
	elif player.set_direction() or walking == false:
		player.update_animation( "Carry_Walk" )
		walking = true
	player.velocity = player.direction * carry_speed
	
	return null
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	if _event.is_action_pressed("Attack") or _event.is_action_pressed("Interact"):
		return idle
	return null
