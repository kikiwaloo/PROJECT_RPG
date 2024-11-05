extends Control
class_name InventoryUi3

const INVENTORY_SLOT = preload("res://Scenes/HUD/Paused_Menu/Inventory/Inventory_Slot.tscn")

@export var data: Inventory_Data
var focus_index: int = 0

func _ready():
	PausedMenu.show.connect( update_inventory )
	PausedMenu.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( _on_inventory_changed )
	

func clear_inventory():
	for c in get_children():
		c.queue_free()
		
func update_inventory( _i: int = 0 ):
	for s in data.equipement_slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		#new_slot.focus_entered.connect( _on_focus_entered )
		
	
#func _on_focus_entered():
	#for i in get_child_count():
		#if get_child( i ).has_focus():
			#focus_index = i
			#return
	#pass
	

func _on_inventory_changed():
	var i = focus_index
	clear_inventory()
	update_inventory( i )
