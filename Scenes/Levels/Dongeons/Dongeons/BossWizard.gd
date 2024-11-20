extends Node2D
class_name WizardBoss

const ENERGIE_EXPLOSION_SCENE: PackedScene = preload("res://Scenes/Levels/Dongeons/Black_Wizzard/energie_explosion.tscn")
const ENERGIE_BALL_SCENE: PackedScene = preload("res://Scenes/Levels/Dongeons/Black_Wizzard/energy_orbs.tscn")
@export var max_hp: int = 10
var hp: int = 10

var current_position: int = 0
var positions: Array[Vector2]
var beam_attack: Array [BeamAttack]
var audio_hurt: AudioStream = preload("res://Art/Boss/boss_hurt.wav")
var audio_shoot: AudioStream = preload("res://Art/Boss/boss_fireball.wav")
var damage_count: int = 0

@onready var animation_player_damage = $BossNode/AnimationPlayer_damage
@onready var animation_player = $BossNode/AnimationPlayer
@onready var cloak_animation_player = $BossNode/CloakSprite/AnimationPlayer
@onready var audio = $BossNode/AudioStreamPlayer2D
@onready var boss_node = $BossNode
@onready var persistence_data_handler = $PersistenceDataHandler
@onready var hurt_box = $BossNode/Hurt_Box
@onready var hit_box = $BossNode/Hit_Box

@onready var hand_01 = $BossNode/CloakSprite/Hand01
@onready var hand_02 = $BossNode/CloakSprite/Hand02
@onready var hand_01_up = $BossNode/CloakSprite/Hand01_UP
@onready var hand_02_up = $BossNode/CloakSprite/Hand02_UP
@onready var hand_01_side = $BossNode/CloakSprite/Hand01_Side
@onready var hand_02_side = $BossNode/CloakSprite/Hand02_Side


func _ready():
		
	hp = max_hp
	hit_box.damaged.connect( damage_taken )
	
	for c in $PositionTargets.get_children():
		positions.append( c.global_position )
	$PositionTargets.visible = false
	teleport( 0 )
	
	for b in $BeamAttack.get_children():
		beam_attack.append( b )
		
		
func _physics_process(_delta):
	hand_01_up.position = hand_01.position
	hand_01_up.frame = hand_01.frame + 4
	hand_02_up.position = hand_02.position
	hand_02_up.frame = hand_02.frame + 4
	hand_01_side.position = hand_01.position
	hand_01_side.frame = hand_01.frame + 8
	hand_02_side.position = hand_02.position
	hand_02_side.frame = hand_02.frame + 12
	
func teleport( _location: int ):
	animation_player.play("Disappear")
	enable_hit_boxes( false )
	damage_count = 0
	if hp < max_hp:
		shoot_orbs()
		
		
	await get_tree().create_timer(1).timeout
	boss_node.global_position = positions[ _location ]
	current_position = _location
	update_animation()
	animation_player.play("appear")
	await animation_player.animation_finished
	idle()
	pass

func idle():
	enable_hit_boxes()
	
	if randf() <= float(hp) / float(max_hp):
		animation_player.play("Idle")
		await animation_player.animation_finished
		if hp < 1:
			return
			
	if damage_count < 1:
		energie_beam_attack()
		animation_player.play("Cast_spell")
		await animation_player.animation_finished
		
	if hp < 1:
		return
			
	var _t: int = current_position
	while _t == current_position:
		_t = randi_range(0, 3)
	teleport( _t )

func update_animation():
	boss_node.scale = Vector2( 1, 1)
	
	hand_01.visible = false
	hand_02.visible = false
	hand_01_up.visible = false
	hand_02_up.visible = false
	hand_01_side.visible = false
	hand_02_side.visible = false
	
	if current_position == 0:
		cloak_animation_player.play("Down")
		hand_01.visible = true
		hand_02.visible = true
	elif current_position == 2:
		cloak_animation_player.play("Up")
		hand_01_up.visible = true
		hand_02_up.visible = true
	else:
		cloak_animation_player.play("Side")
		hand_01_side.visible = true
		hand_02_side.visible = true
		if current_position == 1:
			boss_node.scale = Vector2( -1, 1)
	pass
	
func energie_beam_attack():
	var _b: Array[ int ]
	match current_position:
		0, 2:
			if current_position == 0:
				_b.append( 0 )
				_b.append(randi_range(1, 2))
			else:
				_b.append( 2 )
				_b.append(randi_range(0, 1))
			if hp < 5 :
				_b.append(randi_range(3, 5))
				
		1, 3:
			if current_position == 3:
				_b.append( 5 )
				_b.append(randi_range(3, 4))
			else:
				_b.append( 3 )
				_b.append(randi_range(4, 5))
			if hp < 5:
				_b.append(randi_range(0, 2))
	for b in _b:
		beam_attack[ b ].attack()
	
func shoot_orbs():
	var eb: Node2D = ENERGIE_BALL_SCENE.instantiate()
	eb.global_position = boss_node.global_position + Vector2(0, -34)
	get_parent().add_child.call_deferred( eb )
	play_audio(audio_shoot)
	
func damage_taken(_hurt_box:HurtBox):
	if animation_player_damage.current_animation == "Damage" or _hurt_box.damage == 0:
		return
	play_audio( audio_hurt )
	
	hp = clampi( hp - _hurt_box.damage, 0, max_hp)
	damage_count += 1
	animation_player_damage.play("Damage")
	animation_player_damage.seek( 0 )
	animation_player_damage.queue("default")
	if hp < 1:
		defeat()

func play_audio( _a: AudioStream):
	audio.stream = _a
	audio.play()
	pass

func defeat():
	animation_player.play("Destroy")
	enable_hit_boxes( false )
	persistence_data_handler.set_value()
	await animation_player.animation_finished
	LevelManager.room_finished.emit()
	
func explosion(_p: Vector2 = Vector2.ZERO):
	var e: Node2D = ENERGIE_EXPLOSION_SCENE.instantiate()
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred( e )
	
func enable_hit_boxes( _v: bool = true):
	hit_box.set_deferred( "monitorable", _v )
	hurt_box.set_deferred( "monitoring", _v )
