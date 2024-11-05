extends CharacterBody2D
class_name Enemy

signal dir_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box: HurtBox)
signal enemy_destroy(hurt_box: HurtBox)
signal enemy_falling


const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false
var hole_inside: bool = false

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hit_box = $Hit_Box
@onready var State_machine = $State_Machine
@onready var fall_box = $Fall_Box/CollisionShape2D


func _ready():
	hole_inside = false
	State_machine.initialize(self)
	player = PlayerManager.player
	hit_box.damaged.connect(_on_take_damage)
	
	
func _physics_process(_delta):
	move_and_slide()
	
	
func set_direction(new_direction: Vector2)-> bool:
	direction = new_direction
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int( round(
			( direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[ direction_id ]
		
		
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	dir_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func update_animation(state: String)-> void:
	animation_player.play(state + "_" + anim_direction() )
	
func anim_direction()-> String:
	if cardinal_direction == Vector2.DOWN:
		return "Down"
	elif cardinal_direction == Vector2.UP:
		return "Up"
	else: 
		return "Side"
	
func _on_take_damage(hurt_box: HurtBox):
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else :
		enemy_destroy.emit(hurt_box)

func _on_fall_box_body_entered(_body):
	if hole_inside == true:
		enemy_falling.emit()

func _on_fall_box_body_exited(_body):
	hole_inside = false
