extends Node

signal tilemapboundschanged(bounds: Array[ Vector2 ])
signal level_load_started
signal level_loaded
signal nb_coin_changed(nb_coins)
signal nb_key_changed(nb_keys)
signal nb_arrows_changed( nb_arrows )
signal nb_quarter_heart( quarter_heart )
signal actor_died
signal room_finished
signal variable_changed(variables)
signal mp_changed( mp )
signal nb_pendentif( pententif )
signal nb_bombe_changed( nb_bombe )

var nb_coins: int = 0 : set = set_nb_coin
var nb_keys: int = 0 : set = set_nb_keys
var nb_arrows: int = 0 : set = set_nb_arrows
var quarter_heart: int = 0 : set = set_quarter_heart
var nb_bombe: int = 0 : set = set_nb_bombe


	# QUEST VARIABLES #
var pententif: int = 0 : set = set_nb_pendentif

var title:bool = false

@onready var mp: int = 0 : set = set_max_mp, get = get_max_mp
var max_mp = 100

var current_tilemap_bounds: Array[ Vector2 ]
var target_transition: String
var position_offset: Vector2

var level: Level
var is_panel_visible:bool = false

func _ready():
	await get_tree().process_frame
	level_loaded.emit()
	#PlayerHud.objet_collected.connect( _on_object_collected )
	
	
func change_tilemap_bounds(bounds: Array[ Vector2 ]):
	current_tilemap_bounds = bounds
	tilemapboundschanged.emit(bounds)

func load_new_level(
	level_path: String,
	_target_transition: String,
	_position_offset: Vector2
):

	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path)
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
func set_max_mp(value):
	value = Math.clampi(value, 0, max_mp)
	if value != mp:
		mp = value
		print("MP-" + str(mp))
		mp_changed.emit(mp)
		
func get_max_mp()-> int: return mp

func set_nb_coin(value):
	if value != nb_coins:
		nb_coins = value
		nb_coin_changed.emit(nb_coins)
		print(nb_coins)
		
func set_nb_keys(value):
	if value != nb_keys:
		nb_keys = value
		nb_key_changed.emit(nb_keys)
		
func set_nb_arrows(value):
	if value != nb_arrows:
		nb_arrows = value
		nb_arrows_changed.emit( nb_arrows )
		
func set_quarter_heart(value):
	if value != quarter_heart:
		quarter_heart = value
		nb_quarter_heart.emit( quarter_heart )

func set_nb_pendentif(value):
	if value != pententif:
		pententif = value
		nb_pendentif.emit( pententif )
		
func set_nb_bombe(value):
	if value != nb_bombe:
		nb_bombe = value
		nb_bombe_changed.emit( nb_bombe )
		
#func _on_object_collected(item_data: ItemData):
#
	#if item_data.name == "Green_Rupee":
		#set_nb_coin( nb_coins +1)
	#if item_data.name == "Blue_Rupee":
		#set_nb_coin( nb_coins +5)
	#if item_data.name == "Red_Rupee":
		#set_nb_coin( nb_coins +10)
		

	
		
