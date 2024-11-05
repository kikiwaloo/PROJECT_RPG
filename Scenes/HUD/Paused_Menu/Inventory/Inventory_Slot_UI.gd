extends Button
class_name InventorySlot

var slot_data: SlotData : set = set_slot_data


@onready var texture_rect = $TextureRect
@onready var label = $Label
@onready var select_item = $Select_Item
@onready var cursor_sound = $Cursor_sound

func _ready():
	
	hide_cursor()
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( _on_focus_entered )
	focus_exited.connect( _on_focus_exited )
	pressed.connect( _on_item_pressed )
	
	
func set_slot_data( value: SlotData):
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	
	if slot_data.item_data.type == slot_data.item_data.TYPE.POTION:
		label.text = str(slot_data.quantity)
	if slot_data.item_data.type == slot_data.item_data.TYPE.QUEST:
		label.text = str(slot_data.quantity)
		
	if slot_data.item_data.type == slot_data.item_data.TYPE.EQUIPEMENT:
		slot_data.item_data.use()

func _on_focus_entered():
	#if slot_data != null:
		#if slot_data.item_data != null:
			#PausedMenu.update_item_description( slot_data.item_data.description )
	show_cursor()
	cursor_sound.play()

	pass
	
func _on_focus_exited():
	#PausedMenu.update_item_description("")
	hide_cursor()
	pass

func _on_item_pressed():
	if slot_data:
		if slot_data.item_data.type == slot_data.item_data.TYPE.WEAPON:
			PausedMenu.item_selected.emit(slot_data)
			select_item.play()
			PausedMenu.hide_pause_menu()
			
		elif slot_data.item_data.type == slot_data.item_data.TYPE.QUEST:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			label.text = str( slot_data.quantity )
			PausedMenu.hide_pause_menu()
			PausedMenu.grid_container.update_inventory(0)
			
		else:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			label.text = str( slot_data.quantity )
			
func show_cursor():
	for cursor in [$Cursor]:
		cursor.visible = true
		
func hide_cursor():
	for cursor in [$Cursor]:
		cursor.visible = false
