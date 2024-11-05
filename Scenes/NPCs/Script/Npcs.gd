@tool
@icon( "res://Scenes/NPCs/Icons/npc.svg" )
extends CharacterBody2D
class_name NPC



signal do_behavior_enabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"
var do_behavior : bool = true
var player: Player

@export var npc_resource : NPCResource : set = _set_npc_resource

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	
	setup_npc()
	if Engine.is_editor_hint():
		return
	gather_actionable()
	do_behavior_enabled.emit()
	pass

func gather_actionable():
	for c in get_children():
		if c is Actionable:
			c.start_diag.connect( dialogue_state )
			c.finish_diag.connect( dialogue_finish )
			
func _physics_process(_delta: float) -> void:
	move_and_slide()


func update_animation() -> void:
	animation.play( state + "_" + direction_name )


func update_direction( target_position : Vector2 ) -> void:
	direction = global_position.direction_to( target_position )
	update_direction_name()
	if direction_name == "side" and direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func update_direction_name() -> void:
	var threshold : float = 0.45
	if direction.y < -threshold:
		direction_name = "up"
	elif direction.y > threshold:
		direction_name = "down"
	elif direction.x > threshold || direction.x < -threshold:
		direction_name = "side"


func setup_npc() -> void:
	if npc_resource:
		if sprite:
			sprite.texture = npc_resource.sprite
	pass

func _set_npc_resource( _npc : NPCResource ) -> void:
	npc_resource = _npc
	setup_npc()

func dialogue_state():
	update_direction(PlayerManager.player.global_position)
	state = "idle"
	velocity = Vector2.ZERO
	update_animation()
	do_behavior = false

func dialogue_finish():
	state = "idle"
	update_animation()
	do_behavior = true
	do_behavior_enabled.emit()
