extends Node2D
class_name EnergyOrbs

@export var speed: float = 200

@export var shoot_audio: AudioStream
@export var hit_audio: AudioStream

var direction: Vector2 = Vector2.DOWN

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var hurt_box = $Hurt_Box


func _ready():
	hurt_box.did_damage.connect( hit_player )
	play_audio( shoot_audio )
	get_tree().create_timer( 5 ).timeout.connect( destroy )
	direction = global_position.direction_to(PlayerManager.player.global_position)
	flicker()
	
func _process(delta):
	position += direction * speed * delta
	
	
func hit_player():
	play_audio( hit_audio )
	hurt_box.set_deferred( "monitoring", false)
	pass

func flicker():
	modulate.a = randf() * 0.7 + 0.3
	await get_tree().create_timer( 0.05).timeout
	flicker()
	
func play_audio(_a:AudioStream):
	audio_stream_player_2d.stream = _a
	audio_stream_player_2d.play()

func destroy():
	queue_free()
