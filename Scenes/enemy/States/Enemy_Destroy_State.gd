extends EnemyState
class_name EnemyDestroyName


const  PICKUP = preload("res://Scenes/Items/Item_Pick_up/Item_Pick_Up.tscn")


@export var anim_name: String = "Destroy"
@export var Knockback_speed: float = 200.0
@export var deceleraion_speed: float = 10.0


@export_category("AI")

@export_category("Item drop")
@export var drops: Array[ DropData ]

var direction: Vector2
var damage_position: Vector2

func init():
	enemy.enemy_destroy.connect(_on_enemy_destroy)
	pass
	
func enter()-> void:
	enemy.invulnerable = true
	direction = enemy.global_position.direction_to(damage_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -Knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()
	drop_item()
	
	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> EnemyState:
	enemy.velocity -= enemy.velocity * deceleraion_speed * _delta
	return null
	
func physics(_delta: float)-> EnemyState:
	return null
	
func _on_enemy_destroy(hurt_box: HurtBox):
	damage_position = hurt_box.global_position
	state_machine.change_state(self)

	LevelManager.actor_died.emit(enemy)
	
	
func _on_animation_finished(_a: String):
	enemy.queue_free()
	

func disable_hurt_box():
	var hurt_box: HurtBox = enemy.get_node_or_null( "Hurt_Box" )
	if hurt_box: 
		hurt_box.monitoring = false

func drop_item():
	if drops.size() == 0:
		return
		
	for i in drops.size():
		if drops[ i ] == null or drops[i].item == null:
			continue
		var drop_count: int = drops[i].get_drop_item()
		for j in drop_count:
			var drop: ItemPickUp = PICKUP.instantiate() as ItemPickUp
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position 
			drop.velocity = enemy.velocity.rotated( randf_range(-1.5, 1.5) * randf_range(0.9, 1.5))
