extends Node2D
class_name BossDoor

@onready var animation_player = $AnimationPlayer
@onready var interact_area = $Area2D
@onready var is_open_data = $Is_Open
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var actionable = $Actionable/CollisionShape2D



var is_open: bool = false


func _ready():
	if VariablesWeapons.boss_key == true:
		actionable.disabled = true
	interact_area.area_entered.connect( _on_area_entered )
	interact_area.area_exited.connect( _on_area_exited )
	_on_set_door_state()
	
func player_interact():
	if is_open == true:
		return
	is_open = true
	is_open_data.set_value()
	animation_player.play("Open")

	await animation_player.animation_finished
	collision_shape_2d.disabled = true
		
			
	
func _on_area_entered(_area: Area2D):
	PlayerManager.interact_pressed.connect( player_interact )
	
	
func _on_area_exited(_area:Area2D):
	PlayerManager.interact_pressed.disconnect( player_interact )
	

func _on_set_door_state():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("As_Open.")
	else :
		animation_player.play("default")
