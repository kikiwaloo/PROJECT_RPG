extends EnemyState
class_name EnemyStuntState

@export var anim_name: String = "Stunt"
@export var Knockback_speed: float = 200.0
@export var deceleraion_speed: float = 10.0
@onready var fall_box = $"../../Fall_Box/CollisionShape2D"



@export_category("AI")
@export var next_state: EnemyState

var damage_position: Vector2
var direction: Vector2
var animation_finished: bool = false

	
func init():
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass
	

func enter()-> void:
	enemy.hole_inside = true
	enemy.invulnerable = true
	animation_finished = false
	
	direction = enemy.global_position.direction_to(damage_position)
	
	enemy.set_direction(direction)
	enemy.velocity = direction * -Knockback_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	
func exit()-> void:
	enemy.hole_inside = false
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)

	
func process(_delta: float )-> EnemyState:
	if animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * deceleraion_speed * _delta
	return null
	
func physics(_delta: float)-> EnemyState:
	return null
	
func _on_enemy_damaged(hurt_box: HurtBox):
	damage_position = hurt_box.global_position
	state_machine.change_state(self)
	pass # Replace with function body.

func _on_animation_finished(_a: String):
	animation_finished = true


