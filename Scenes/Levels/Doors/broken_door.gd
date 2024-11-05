extends Node2D
class_name BrokenDoor

@onready var animation_player = $AnimationPlayer
@onready var broken_zone = $Broken_Zone
@onready var is_open_data = $Is_Open
@onready var audio = $AudioStreamPlayer2D

var is_open: bool = false

func _ready():
	is_open_data.data_loaded.connect( set_open_data )
	set_open_data()

func broken():
	if is_open == true:
		return
	is_open = true
	is_open_data.set_value()
	audio.play()
	animation_player.play("Broken")
	await animation_player.animation_finished
	queue_free()
	
func _on_broken_zone_area_entered(_area):
	broken()

func set_open_data():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("As_Broken")
	else :
		animation_player.play("Default")
