@tool
extends Node2D
class_name ShopPickUp

@export var item: ItemData: set = _set_item_data
@export var price: int: set = _set_price
@export var quantity: int: set = _set_quantity

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@onready var sprite = $Sprite2D
@onready var interact_area = $Area2D
@onready var label_price = $Sprite2D/Price
@onready var label_quantity = $Sprite2D/Quantity
@onready var audio = $AudioStreamPlayer


func _ready():
	_update_label_price()
	_update_texture()
	_update_quantity()
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_interact_area_entered )
	interact_area.area_exited.connect( _on_interact_area_exited )

func player_interact():
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	if LevelManager.nb_coins < price:
		audio.play()
	else:
		if PlayerManager.INVENTORY_DATA.add_items( item ) == true:
			item.shop_take()
		if item.type == item.TYPE.OBJECT:
			item.shop_take()

	
func _set_item_data(value: ItemData):
	if value != item:
		item = value
		_update_texture()
		
func _set_price(value: int):
	if value != price:
		price = value
		_update_label_price()
		
func _set_quantity(value: int):
	if value != quantity:
		quantity = value
		_update_quantity()
		
func _update_label_price():
	if label_price:
		if price <= 1:
			label_price.text = ""
		else :
			label_price.text = str(price) + "R"
			
func _update_texture():
	if item and sprite:
		sprite.texture = item.texture
		
func _update_quantity():
	if label_quantity:
		if quantity <= 1:
			label_quantity.text = ""
		else:
			label_quantity.text = "X" + str(quantity) 
			
func _on_interact_area_entered(_a: Area2D):
	PlayerManager.interact_pressed.connect( player_interact )
	
func _on_interact_area_exited(_a: Area2D):
	PlayerManager.interact_pressed.disconnect( player_interact )
