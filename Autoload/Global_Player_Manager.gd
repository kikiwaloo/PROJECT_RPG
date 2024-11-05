extends Node

const PLAYER = preload("res://Scenes/Player/player.tscn")
const INVENTORY_DATA = preload("res://Scenes/HUD/Paused_Menu/Inventory/Player_Inventory.tres")

signal interact_pressed
signal item_in_hand(item_in_hand)
signal fall_damaged( hurt_box : FallBox )
signal mp_changed( mp )
signal use_item

var interact_handled: bool = true
var player : Player
var player_spawner = false
var current_checkpoint: CheckPoint


func _ready():
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	#player_spawner = true
	
	pass
	
func add_player_instance():
	player = PLAYER.instantiate()
	add_child( player )

	
func set_health(hp: int, max_hp: int):
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( max_hp )
	
	
func set_player_position(new_pos: Vector2):

	player.global_position = new_pos
	
func set_as_parent(_p: Node2D):
	if player.get_parent():
		player.get_parent().remove_child( player )
	
	_p.add_child( player )
		
func unparent_player(_p: Node2D):
	_p.remove_child( player )
	
func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func play_audio( _audio: AudioStream):
	player.audio.stream = _audio
	player.audio.play() 

func interact():
	interact_handled = false
	interact_pressed.emit()
