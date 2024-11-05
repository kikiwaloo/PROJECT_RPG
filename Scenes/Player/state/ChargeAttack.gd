extends State
class_name State_ChargeAttack

@export var charge_duration : float = 1.0
@export var move_speed : float = 80.0
@export var sfx_charged : AudioStream
@export var sfx_spin : AudioStream

var timer : float = 0.0
var walking : bool = false
var is_attacking : bool = false
var particles : ParticleProcessMaterial

@onready var idle = $"../IDLE"
@onready var charge_attack_box = %ChargeAttack_Box
@onready var charge_spin = %ChargeSpin
@onready var audio_stream_player_2d = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_effect = $"../../Sprite2D/SpinEffect"
@onready var spin_animation_player = $"../../Sprite2D/SpinEffect/AnimationPlayer"
@onready var gpu_particles_2d = $"../../Sprite2D/ChargeAttack_Box/GPUParticles2D"





func _ready():
	pass
	
func init():
	gpu_particles_2d.emitting = false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	
	spin_effect.visible = false
	pass
	
	
func enter()-> void:
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_attack_box.monitoring = true
	gpu_particles_2d.emitting = true
	gpu_particles_2d.amount = 4
	pass
	
func exit()-> void:
	charge_attack_box.monitoring = false
	charge_spin.monitoring = false
	spin_effect.visible = false
	gpu_particles_2d.emitting = false
	pass
	
	
func process(_delta: float )-> State:
	if timer > 0:
		timer -= _delta
		if timer <= 0:
			timer = 0
			charge_complete()
			
	if is_attacking == false:
		if player.direction == Vector2.ZERO:
			walking = false
			player.update_animation( "Charge" )
		elif player.set_direction() or walking == false:
			walking = true
			player.update_animation( "Charge_Walk" )
			
	player.velocity = player.direction * move_speed
	return null
	
func physics(_delta: float)-> State:
	return null
	
func handle_input(_event: InputEvent)-> State:
	if _event.is_action_released("Attack"):
		if timer > 0:
			return idle
		elif is_attacking == false:
			charge_attack()
	
	return null

func charge_attack():
	is_attacking = true
	player.animation_player.play( "Charge_Attack" )
	player.animation_player.seek( get_spin_frame() )
	play_audio( sfx_spin )
	spin_effect.visible = true
	spin_animation_player.play("Spin")
	var _duration : float = player.animation_player.current_animation_length
	player.make_cooldown( _duration )
	charge_spin.monitoring = true
	await get_tree().create_timer(_duration * 0.875).timeout
	state_machine.change_state( idle )
	
	
func charge_complete():
	play_audio( sfx_charged )
	gpu_particles_2d.amount = 50
	gpu_particles_2d.explosiveness = 1
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	await get_tree().create_timer( 0.5 ).timeout
	gpu_particles_2d.amount = 10
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	pass

func get_spin_frame()-> float:
	var interval : float = 0.05
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0
		Vector2.UP:
			return interval * 4
		_:
			return interval * 6

func play_audio(_audio: AudioStream):
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	
	pass
