extends State
class_name StuntState

@export var kcnocback_speed: float = 200.0
@export var deceleration_speed: float = 10.0
@export var cooldown_duration: float = 1.0

@onready var idle: State = $"../IDLE"
@onready var low_health = $"../../Low_Health"
@onready var dead = $"../DEAD"

var next_state: State = null
var hurt_box: HurtBox
var direction: Vector2

func init():
	player.player_damage.connect(_on_player_damage)
	
func enter()-> void:
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -kcnocback_speed
	player.set_direction()
	
	player.update_animation("Stunt")
	player.make_cooldown(cooldown_duration)
	player.effect_damage.play("Damage")
	pass
	
func exit()-> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass
	
	
func process(_delta: float )-> State:
	player.velocity -= player.velocity * deceleration_speed * _delta
	return next_state
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	return null

func _on_player_damage(_hurt_box: HurtBox):
	hurt_box = _hurt_box
	if state_machine.current_state != dead:
		state_machine.change_state(self)
	pass

func _on_animation_finished(_anim: String):
	next_state = idle
	
	if player.hp <= 0:
		next_state = dead
	

