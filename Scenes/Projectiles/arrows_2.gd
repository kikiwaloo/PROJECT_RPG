extends Node2D
class_name Arrows


enum State { INACTIVE, SHOOT, BROKEN }

var player : Player
var direction := Vector2.RIGHT.rotated(rotation)
var speed : float = 400.0
var state

@export var acceleration : float = 500.0
@export var max_speed : float = 400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer = $Timer


func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player


func _physics_process( delta: float ) -> void:
	if state == State.SHOOT:
		var velocity = direction * speed * delta
		global_position += velocity

func shoot( shoot_direction : Vector2 ) -> void:
	direction = shoot_direction
	timer.start()
	state = State.SHOOT
	animation_player.play( "Arrow" )
	visible = true
	LevelManager.set_nb_arrows( LevelManager.nb_arrows -1)
	if LevelManager.nb_arrows == 0:
		VariablesWeapons.arrows = false
	pass


func _on_hurt_box_area_entered(area):
	if area is HitBox:
		queue_free()

func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(_body):
	self.queue_free()
