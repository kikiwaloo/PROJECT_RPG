extends RigidBody2D
class_name PushableObject

signal position_changed

@export var push_speed: float = 30.0

var push_direction = Vector2.ZERO : set = set_push_direction
var current_position := Vector2(position) : set = set_current_position
var new_pos : Vector2 = current_position


@onready var audio = $AudioStreamPlayer2D


func _ready():
	pass

	
func _physics_process(_delta):
	linear_velocity = push_direction * push_speed
	pass
	
func set_current_position(value: Vector2):
	if value != current_position:
		current_position = value
		position_changed.emit()
		print("current_position-" + str(current_position))
		
func set_push_direction( value: Vector2):
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
