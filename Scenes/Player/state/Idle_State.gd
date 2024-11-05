extends State
class_name Idle_State



@onready var walk = $"../WALK"
@onready var attack = $"../ATTACK"
var item_data


@onready var area_2d = $"../../Interaction/Area2D"

func enter()-> void:
	player.update_animation("Idle")
	pass
	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> State:
	if player.direction != Vector2.ZERO:
		return walk
		
	player.velocity = Vector2.ZERO
	return null
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	if _event.is_action_pressed("Attack"):
		if VariablesWeapons.VARIABLES.sword == true: 
			return attack
			
	if _event.is_action_pressed("Interact"):
		var interaction = area_2d.get_overlapping_areas()
		if interaction.size() > 0:
			interaction[0].action()
			return
		else:
			PlayerManager.interact()
		
	if _event.is_action_pressed("Lampe"):
		if VariablesWeapons.VARIABLES.lantern == true:
			VariablesWeapons.active_lantern = not VariablesWeapons.active_lantern
			print(VariablesWeapons.active_lantern)
	return null
