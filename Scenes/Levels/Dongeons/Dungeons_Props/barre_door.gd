extends Node2D
class_name BarreDoor

var is_open: bool = false

@onready var animation_player = $AnimationPlayer
@onready var check_open = $Check_Open


func _ready():
	pass
	
func open_door():
	animation_player.play( "door_open" )
	check_open.play()
	
func close_door():
	animation_player.play( "door_close" )


