extends EnemyState
class_name EnemyChaseState

@export var anim_name: String = "Chase"
@export var chase_speed: float = 40.0
@export var turn_rate: float = 0.25


@export_category("AI")
@export var vision_area: VisionArea
@export var attack_area: HurtBox
@export var state_aggro_duration: float = 0.5
@export var next_state: EnemyState

var timer: float = 0.0
var direction: Vector2
var can_see_player: bool = false


func init():
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter )
		vision_area.player_exited.connect( _on_player_exit )
	pass
	
	
func enter()-> void:
	timer = state_aggro_duration
	enemy.update_animation(anim_name)
	can_see_player = true
	if attack_area:
		attack_area.monitoring = true
	pass
	
func exit()-> void:
	if attack_area:
		attack_area.monitoring = false
	can_see_player = false
	pass
	
	
func process(_delta: float )-> EnemyState:
	if PlayerManager.player.hp <= 0 :
		return next_state
		
	var new_dir: Vector2 = enemy.global_position.direction_to(PlayerManager.player.global_position)
	direction = lerp( direction, new_dir, turn_rate )
	enemy.velocity = direction * chase_speed
	if enemy.set_direction(direction):
		enemy.update_animation( anim_name )
		
		
	if can_see_player == false:
		timer -= _delta
		if timer < 0:
			return next_state
	else :
		timer = state_aggro_duration
	return null
	
func physics(_delta: float)-> EnemyState:
	return null

func _on_player_enter():
	can_see_player = true
	if(
			state_machine.current_state is EnemyStuntState
			or state_machine.current_state is EnemyDestroyName
			or state_machine.current_state is EnemyFallingState
	):
		return

	state_machine.change_state( self )
	
func _on_player_exit():
	can_see_player = false
	pass

