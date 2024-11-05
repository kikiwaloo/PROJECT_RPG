extends State
class_name  FallingState

@export var knockback_speed : float = 20.0
@export var decelerate_speed : float = 10.0
@export var cooldown_duration : float = 1.0

var hurt_box : HoleTrap
var hole: HoleTrap
var direction : Vector2

var next_state : State = null

@onready var idle : State = $"../IDLE"


func init():
	player.player_falling.connect(_on_player_damage)
	
func enter()-> void:
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	
	player.set_direction()
	
	player.update_animation("Falling")

	
	
func exit()-> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	
	
func process(_delta: float )-> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	return null

func _on_player_damage(_hurt_box: HoleTrap):
	hurt_box = _hurt_box
	state_machine.change_state(self)
	pass

func _on_animation_finished( _a: String ) -> void:
	if player.hp == 0:
		player.velocity = Vector2.ZERO
		player.player_dead.emit()
	else:
		PlayerManager.respawn_player()
		next_state = idle
