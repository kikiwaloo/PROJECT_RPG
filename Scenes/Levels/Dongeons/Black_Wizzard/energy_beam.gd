extends Node2D
class_name BeamAttack

@export var use_timer: bool = false
@export var time_bethween_attack: float = 3

@onready var animation_player = $AnimationPlayer


func _ready():
	if use_timer == true:
		attack_delay()


func attack():
	animation_player.play("Attack")
	await animation_player.animation_finished
	animation_player.play("Default")
	if use_timer == true:
		attack_delay()
		
func attack_delay():
	await get_tree().create_timer( time_bethween_attack).timeout
	attack()
