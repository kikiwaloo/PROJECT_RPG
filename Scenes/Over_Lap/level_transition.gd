@tool
extends Area2D
class_name LevelTransition


enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level 
@export var target_transition_area: String = ""
@export var center_player: bool = false

@export_category( "collision area setting")

@export_range(1, 12, 1, "or_greater") var size: int = 2 :
	set(_v):
		size = _v
		update_area()
		
@export var side: SIDE = SIDE.LEFT:
	set(_v):
		side = _v
		update_area()
		
@export var snap_to_grid: bool = false:
	set(_v):
		_snap_to_grid()
		
@onready var collision_shape = $CollisionShape2D


func _ready():
	update_area()
	
	if Engine.is_editor_hint():
		return
		
	_place_player()
	
	#await LevelManager.level_loaded
	
	monitoring = true
	body_entered.connect(_on_body_enterded)
	pass

func _on_body_enterded(_player: Node2D):
	LevelManager.load_new_level( level, target_transition_area, _get_offset() )
	
	pass

func _place_player():
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position( global_position + LevelManager.position_offset)
	
func _get_offset()-> Vector2:
	var offset = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if center_player == true:
			offset.y = 0
		else:
			offset.y = player_pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else :
		if center_player == true:
			offset.x = 0
		else:
			offset.x = player_pos.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1
	return offset
	
func update_area():
	var new_rect: Vector2 = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position
		
func _snap_to_grid():
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16
