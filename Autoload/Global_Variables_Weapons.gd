extends Node

signal selected_abilities

var active_lantern: bool = false

	# POTION VARIABLES #
var red_potion: bool = false
var green_potion: bool = false
var blue_potion: bool = false
var resurection_potion = false

	# PROGECTILES VARIABLES #
var bombe: bool = false
var arrows: bool = false

	# QUEST OBJECT VARIABLES #
var small_key: bool = false
var boss_key: bool = false

	# GAME VARIABLES #
var VARIABLES: Dictionary = {
	lantern = true,
	sword =true
} : set = set_variable_changed
var item_pick_up: bool = false

	# WEAPON VARIABLES #
var bow: bool = false
var boomerang: bool = false

func _ready():
	PlayerManager.item_in_hand.connect( _on_item_in_hand )
	pass
	
func _on_item_in_hand(item_in_hand: SlotData):
	if item_in_hand.item_data.name == "Bow":
		bow = true
	else:
		bow = false
	if item_in_hand.item_data.name == "Boombrang":
		boomerang = true
	else :
		boomerang = false
	if item_in_hand.item_data.name == "Bombe":
		bombe = true
	else:
		bombe = false

	selected_abilities.emit()

func set_variable_changed(value):
	if value != VARIABLES:
		VARIABLES = value
		
		print(VARIABLES)

