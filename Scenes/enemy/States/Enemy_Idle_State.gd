extends EnemyState
class_name EnemyIdleState


@export var anim_name: String = "Idle"
@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var after_idle_state: EnemyState

var timer: float = 0.0

# Called when the node enters the scene tree for the first time.

func init():
	pass
	
	
func enter()-> void:
	enemy.velocity = Vector2.ZERO
	timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)
	pass
	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> EnemyState:
	timer -= _delta
	if timer <= 0:
		return after_idle_state
	return null
	
func physics(_delta: float)-> EnemyState:
	return null
