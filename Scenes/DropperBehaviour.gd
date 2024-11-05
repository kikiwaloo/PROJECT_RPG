extends Node2D
class_name DropperBehaviour


const  PICKUP = preload("res://Scenes/Items/Item_Pick_up/Item_Pick_Up.tscn")


@export_category("Item drop")
@export var drops: Array[ DropData ]

@export var object: Node2D

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
			object.get_parent().call_deferred("add_child", drop)
			drop.global_position = object.global_position 
			#drop.velocity = object.velocity.rotated( randf_range(-1.5, 1.5) * randf_range(0.9, 1.5))
