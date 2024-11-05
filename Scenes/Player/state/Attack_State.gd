extends State
class_name Attack_State


@export var attack_sound = AudioStream
@export_range(1,20,0.5) var decelerate_speed: float = 5.0

@onready var idle : State = $"../IDLE"
@onready var walk : State = $"../WALK"
@onready var anim_player = $"../../AnimationPlayer"
@onready var anim_attack = $"../../Sprite2D/Attack_sprite/Attack_Anim"
@onready var audio = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box = %AttackHurt_Box
@onready var charge_attack = $"../CHARGEATTACK"


var attacking: bool = false

func enter()-> void:
	player.update_animation("Attack")
	anim_attack.play("Attack_" + player.animation_direction())
	anim_player.animation_finished.connect(end_attack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true

	
func exit()-> void:
	anim_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass
	
	
func process(_delta: float )-> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else :
			return walk
	return null
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	return null

func end_attack(_new_anim_name: String):
	if Input.is_action_pressed("Attack"):
		state_machine.change_state( charge_attack )
	attacking = false
