extends EnemyState
class_name EnemyAttack

@onready var attaque_zone = $"../../Attaque_Zone"
@export var anim_name: String = "Attack"
@export var next_state: EnemyState


var can_attack:bool = false
var animation_finished:bool = false

func init():
	attaque_zone.body_entered.connect( _on_body_entered )
	attaque_zone.body_exited.connect( _on_body_exited )

func enter():

	animation_finished = false
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)

	
func exit():
	
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass
	
func process(_delta: float )-> EnemyState:
	if animation_finished == true:
		return next_state
	return null
	

func _on_body_entered(body):
	if body is Player:
		can_attack = true
		if(
				state_machine.current_state is EnemyStuntState
				or state_machine.current_state is EnemyDestroyName
				or state_machine.current_state is EnemyFallingState
		):
			return

		state_machine.change_state( self )
		print("attack")
	
	
func _on_body_exited(body):
	if body is Player:
		can_attack = false
		print("no_attack")

func _on_animation_finished(_a: String):
	animation_finished = true
