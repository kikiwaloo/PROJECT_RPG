extends Node2D
class_name DoorKey

@onready var animation_player = $AnimationPlayer
@onready var interact_area = $Detection_Zone
@onready var is_open_data = $Is_Open
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D



var is_open: bool = false


func _ready():

	interact_area.area_entered.connect( _on_area_entered )
	interact_area.area_exited.connect( _on_area_exited )
	is_open_data.data_loaded.connect( _on_set_door_state )
	_on_set_door_state()
	
func player_interact():
	if VariablesWeapons.small_key == true:
		if is_open == true:
			return
		is_open = true
		is_open_data.set_value()
		animation_player.play("open_door")
		LevelManager.set_nb_keys( LevelManager.nb_keys -1 )
		await animation_player.animation_finished
		collision_shape_2d.disabled = true
		
	if LevelManager.nb_keys <= 0:
		VariablesWeapons.small_key = false
			
	print(VariablesWeapons.small_key)
	print(LevelManager.nb_keys)
	
func _on_area_entered(_area: Area2D):
	PlayerManager.interact_pressed.connect( player_interact )
	
	
func _on_area_exited(_area:Area2D):
	PlayerManager.interact_pressed.disconnect( player_interact )
	

func _on_set_door_state():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else :
		animation_player.play("closed")
