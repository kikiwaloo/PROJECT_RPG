@tool
extends Node2D
class_name InteractChest

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
	if is_open == true:
		return
	is_open = true
	is_open_data.set_value()
	animation_player.play("Open_Chest")
	#await animation_player.animation_finished
	
	
	if item_data.type == item_data.TYPE.WEAPON:
		if item_data and quantity > 0:
			PlayerManager.INVENTORY_DATA.add_items( item_data, quantity)
		if item_data.name == "Lantern":
			item_data.take()
			show_panel()
			
	elif item_data.type == item_data.TYPE.OBJECT:
		
		if item_data.name == "Key":
			item_data.take()
		elif item_data.name == "Big_Key":
			item_data.take()
		elif item_data.name == "Arrows":
			LevelManager.set_nb_arrows( LevelManager.nb_arrows + quantity )
			item_data.take()
		elif item_data.name == "Quarter_Heart":
			item_data.take()
		else:
			LevelManager.set_nb_coin( LevelManager.nb_coins + quantity )
		#PlayerHud.objet_collected.emit(item_data)
		
	elif item_data.type == item_data.TYPE.QUEST:
		PlayerManager.INVENTORY_DATA.add_items( item_data, quantity)
		item_data.take()
		
	elif item_data.type == item_data.TYPE.POTION:
		if item_data and quantity > 0:
			PlayerManager.INVENTORY_DATA.add_items( item_data, quantity)
			
	elif item_data.type == item_data.TYPE.EQUIPEMENT:
		show_panel()
		if item_data and quantity > 0:
			PlayerManager.INVENTORY_DATA.add_items( item_data, quantity)
		if item_data.name == "Sword":
			item_data.take()
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
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

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
