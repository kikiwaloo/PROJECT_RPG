extends Node2D
class_name DoorEnemy

var is_open: bool = false

@onready var animation_player = $AnimationPlayer
@onready var check_open = $Check_Open
@onready var audio_close_door = $close_door
@onready var is_open_data = $Is_Open




func _ready():
	LevelManager.room_finished.connect( _on_room_finished )
	is_open_data.data_loaded.connect( _on_door_state )
	await get_tree().create_timer(0.2).timeout
	close_door()
	_on_door_state()
	
	
func open_door():
	is_open = true
	is_open_data.set_value()
	animation_player.play( "door_open" )
	check_open.play()
	
func close_door():
	animation_player.play( "door_close" )
	audio_close_door.play()
	
func _on_room_finished():
	open_door()

func _on_door_state():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("door_open")
		check_open.play()
	else :
		animation_player.play("door_close")
