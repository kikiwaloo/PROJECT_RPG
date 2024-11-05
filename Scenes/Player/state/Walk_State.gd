extends State
class_name Walk_State

@export var move_speed : float = 100.0

@onready var idle : State = $"../IDLE"
@onready var attack = $"../ATTACK"


func enter()-> void:
	player.update_animation("Walk")
	pass
	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("Walk")
	
	return null
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	if _event.is_action_pressed("Attack"):
		if VariablesWeapons.VARIABLES.sword == true: 
			return attack
	if _event.is_action_pressed("Interact"):
		PlayerManager.interact()
	if _event.is_action_pressed("Lampe"):
		if VariablesWeapons.VARIABLES.lantern == true:
			VariablesWeapons.active_lantern = not VariablesWeapons.active_lantern
	return null
