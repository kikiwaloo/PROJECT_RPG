extends TextureRect
class_name ItemContenaire

@onready var item = $CenterContainer/item


func _ready():
	PausedMenu.item_selected.connect( _on_item_selected )
	
	
func _on_item_selected(item_in_hand: SlotData):
	item.set_texture(item_in_hand.item_data.texture)
	PlayerManager.item_in_hand.emit(item_in_hand)

	
