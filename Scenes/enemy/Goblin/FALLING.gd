extends EnemyState
class_name EnemyFallingState

@export var anim_name: String = "Falling"
@export var Knockback_speed: float = 200.0
@export var deceleraion_speed: float = 10.0


var direction: Vector2
var damage_position: Vector2

func init():
	enemy.enemy_falling.connect(_on_enemy_falling)
	pass
	
func enter()-> void:
	enemy.invulnerable = true
	direction = enemy.global_position.direction_to(damage_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -Knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	#disable_hurt_box()
	
	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> EnemyState:
	enemy.velocity -= enemy.velocity * deceleraion_speed * _delta
	return null
	
func physics(_delta: float)-> EnemyState:
	return null
	
func _on_enemy_falling():
	
	state_machine.change_state(self)

	LevelManager.actor_died.emit(enemy)
	
	
func _on_animation_finished(_a: String):
	enemy.queue_free()
	

#func disable_hurt_box():
	#var hurt_box: HurtBox = enemy.get_node_or_null( "Hurt_Box" )
	#if hurt_box: 
		#hurt_box.monitoring = false
