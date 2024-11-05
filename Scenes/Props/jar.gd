extends Node2D
class_name Jar


const  PICKUP = preload("res://Scenes/Items/Item_Pick_up/Item_Pick_Up.tscn")

@export_category("Item drop")
@export var drops: Array[ DropData ]


@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D
@onready var hit_box = $Hit_Box
@onready var collision_hit_box = $Hit_Box/CollisionShape2D

var spawn_h_force : float = 200.0
var spawn_dir_force : float = 200.0
var spawn_dir := Vector2.ZERO
var spawn_dir_velocity := Vector2.ZERO
var damping := 50.0

func _ready():
	$Hit_Box.damaged.connect(take_damage)
	
func take_damage(_hurt_box: HurtBox):
	drop_item()
	animation_player.play("Destroy")
	await animation_player.animation_finished
	queue_free()
	
	
func drop_item():
	if drops.size() == 0:
		return
		
	for i in drops.size():
		if drops[ i ] == null or drops[i].item == null:
			continue
		var drop_count: int = drops[i].get_drop_item()
		for j in drop_count:
			var spawn_h_velocity = Vector2(spawn_h_force,0.0)
			spawn_dir_velocity = spawn_dir * spawn_dir_force
			spawn_dir_velocity = spawn_dir_velocity.limit_length(spawn_dir_velocity.length() - damping)
	
			var _velocity = spawn_h_velocity + spawn_dir_velocity
			
			var drop: ItemPickUp = PICKUP.instantiate() as ItemPickUp
			drop.item_data = drops[i].item
			self.get_parent().call_deferred("add_child", drop)
			drop.global_position = self.global_position
			drop.velocity = _velocity.rotated( randf_range(-1.5, 1.5) * randf_range(0.9, 1.5))


func _on_area_2d_body_entered(_body):
	print("return")
