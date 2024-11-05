extends CharacterBody2D
class_name Player


signal dir_changed(new_direction: Vector2)
signal player_damage(hurt_box: HurtBox)
signal player_dead
signal player_falling


const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var cooldown: bool = false
var hp: int = 20
var max_hp: int = 20

@onready var hit_box = $Hit_Box
@onready var effect_damage = $Effect_Damage
@onready var animation_player = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine = $State_Machine
@onready var push_area = $Interaction/PushArea
@onready var audio = $Audio/AudioStreamPlayer2D
@onready var spawn_projectile = $Spawn_Projectile
@onready var fall_box = $Fall_Box
@onready var area_2d = $Interaction/Area2D
@onready var lift = $State_Machine/LIFT
@onready var held_item = $Sprite2D/HeldItem
@onready var carry = $State_Machine/CARRY


	# Audio Variable #

@onready var add_heart = $Add_Heart
@onready var low_health = $Low_Health
@onready var error_sound = $Error_Sound
@onready var arrow_sound = $Arrow_Sound



var item: SlotData

func _ready():
	PausedMenu.add_heart.connect( _on_add_heart )
	PlayerManager.player = self
	state_machine.initialize(self)
	hit_box.damaged.connect(_on_take_damaged)
	fall_box.fall_damaged.connect( _take_fall_damaged )
	
	update_hp(hp)
		
func _process(_delta):
	
#	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
#	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
#	direction = direction.normalized()
	pass
		
func _physics_process(_delta):
	direction = Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	).normalized()
	
	move_and_slide()
	
func set_direction()-> bool:
	if direction == Vector2.ZERO:
		return false
		
	var direction_id = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[direction_id]
		
		
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	dir_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	set_spawn_projectile()
	set_push_area_direction()
	return true
	
func set_spawn_projectile():
	var angle = cardinal_direction.angle()
	spawn_projectile.set_rotation_degrees(rad_to_deg(angle) -360)
	
func set_push_area_direction():
	var angle = cardinal_direction.angle()
	push_area.set_rotation_degrees(rad_to_deg(angle) -90)
	
func update_animation(state: String)-> void:
	animation_player.play(state + "_" + animation_direction())
	pass
	
func animation_direction()-> String:
	if cardinal_direction == Vector2.DOWN:
		return "Down"
	elif cardinal_direction == Vector2.UP:
		return "Up"
	else :
		return "Side"

func update_hp(delta: int):
	hp = clampi( hp + delta, 0, max_hp)
	PlayerHud.update_hp( hp, max_hp)
	if hp <= 2:
		low_health.play()
	else:
		low_health.stop()
	print(hp)

func make_cooldown(duration: float = 1.0):
	cooldown = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(duration).timeout
	cooldown = false
	hit_box.monitoring = true
	
	
		##########################
		#### SIGNAL RESPONCES ####
		##########################

func _on_add_heart():
	PlayerManager.set_health(hp + 2,max_hp + 2)
	PlayerHud.update_hp(hp, max_hp )
	add_heart.play()
	
func _on_take_damaged(hurt_box: HurtBox):
	if cooldown == true:
		return
	if hp > 0 :
		update_hp(-hurt_box.damage)
		player_damage.emit(hurt_box)
	
		
func _take_fall_damaged( hurt_box: HoleTrap):
	if state_machine.states is StuntState:
		player_falling.emit( hurt_box )
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_falling.emit( hurt_box )

	else: 
		player_falling.emit( hurt_box )
		update_hp( hp )


func _on_area_2d_area_entered(area):
	if area is LampReco:
		var interaction = area_2d.get_overlapping_areas()
		if interaction.size() > 0:
			interaction[0].action()
			return
	pass # Replace with function body.

func attack():
	animation_player.play("Falling_Down")
	await animation_player.animation_finished
	animation_player.play("Falling_Up")
	await animation_player.animation_finished
	animation_player.play("Dead_Down")
	await animation_player.animation_finished
	animation_player.play("Idle_Down")

func pick_up_item(_t: Throwable):
	state_machine.change_state( lift )
	carry.throwable = _t
