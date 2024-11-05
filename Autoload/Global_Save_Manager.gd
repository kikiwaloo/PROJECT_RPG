extends Node

const SAVE_PATH = "user://"


signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
		rupees = 1,
		keys = 1,
		arrows = 1,
		quarter_heart = 1
	},
	_variables = {
		_sword = false,
		_lantern = false,
		_boomerang = false,
		_bow = false
	},
	items = [],
	potion = [],
	equipement = [],
	persistence = [],
	quest = [],
	object = {
		pos_x = 0,
		pos_y = 0
	}
}


func save_game():
	
	update_player_data()
	update_scene_path()
	update_item_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	
func get_save_file()-> FileAccess:
	return FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ)
	
func load_game():
	var file := get_save_file()
	var json := JSON.new()
	json.parse( file.get_line() )
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO)
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y) )
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	LevelManager.set_nb_coin(current_save.player.rupees)
	LevelManager.set_nb_keys(current_save.player.keys)
	LevelManager.set_nb_arrows(current_save.player.arrows)
	LevelManager.set_quarter_heart(current_save.player.quarter_heart)
	VariablesWeapons.set_variable_changed(current_save._variables)
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	PlayerManager.INVENTORY_DATA.parse_save_potion_data( current_save.potion)
	PlayerManager.INVENTORY_DATA.parse_save_equipement_data( current_save.equipement )
	await LevelManager.level_loaded
	game_loaded.emit()

	
func update_player_data():
	var p: Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	current_save.player.rupees = LevelManager.nb_coins
	current_save.player.keys = LevelManager.nb_keys
	current_save.player.arrows = LevelManager.nb_arrows
	current_save.player.quarter_heart = LevelManager.quarter_heart
	current_save._variables = VariablesWeapons.VARIABLES

	print("variable" + str(VariablesWeapons.VARIABLES))
	
func update_scene_path():
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p
	
func update_item_data():
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
	current_save.potion = PlayerManager.INVENTORY_DATA.get_save_potion_data()
	current_save.equipement = PlayerManager.INVENTORY_DATA.get_save_equipement_data()
	
func add_persistence_value( value: String):
	if check_persistence_value( value ) == false:
		current_save.persistence.append( value )
	
func check_persistence_value( value: String)-> bool:
	var p = current_save.persistence as Array
	return p.has( value )
