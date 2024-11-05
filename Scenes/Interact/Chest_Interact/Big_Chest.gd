@tool
extends Node2D
class_name BigChest

@export var item_data: ItemData: set = _set_item_data
@export var quantity: int = 1: set = _set_quantity
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var is_open: bool = false

@onready var sprite = $Item_Sprite
@onready var label = $Item_Sprite/Label
@onready var interact_area = $Area2D
@onready var animation_player = $AnimationPlayer
@onready var is_open_data: PersistenceDataHandler = $Is_Open




#### BUILT_IN ####

func _ready():
	_update_texture()
	_update_label()
	
	if Engine.is_editor_hint():
		return
		
	interact_area.area_entered.connect( _on_interact_area_entered )
	interact_area.area_exited.connect( _on_interact_area_exited )
	is_open_data.data_loaded.connect( _on_set_chest_state )
	_on_set_chest_state()
	
func _set_item_data( value: ItemData):
	item_data = value
	_update_texture()

	
func _set_quantity(value: int ):
	if value != quantity:
		quantity = value
		_update_label()


func player_interact():
	if VariablesWeapons.boss_key == true:
		if is_open == true:
			return
		is_open = true
		is_open_data.set_value()
		animation_player.play("Open_Chest")
		
		if item_data.type == item_data.TYPE.WEAPON:
			if item_data and quantity > 0:
				PlayerManager.INVENTORY_DATA.add_items( item_data, quantity)
				show_panel()
		elif item_data.type == item_data.TYPE.OBJECT:
			if item_data.name == "Big_Key":
				item_data.use()
				
			PlayerHud.objet_collected.emit(item_data)

		else :
			printerr("No item in chest")
			push_error("No item in chest! Chest name:" , name)


func _update_texture():
	if item_data and sprite:
		sprite.texture = item_data.texture
		
func _update_label():
	if label:
		if quantity <= 1:
			label.text = ""
		else :
			label.text = "x" + str(quantity)
			
func show_panel():
	if is_open == true:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		
	#### SIGNAL RESPONCES ####
	
func _on_interact_area_entered(_a: Area2D):
	PlayerManager.interact_pressed.connect( player_interact )
	
	
	
func _on_interact_area_exited(_a: Area2D):
	PlayerManager.interact_pressed.disconnect( player_interact ) 
	

func _on_set_chest_state():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("Opened")
	else :
		animation_player.play("Closed")
