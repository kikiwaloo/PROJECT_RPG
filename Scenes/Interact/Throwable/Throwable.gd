extends Area2D
class_name Throwable


@export var gravity_strenght: float = 980
@export var throw_speed: float = 400.0
@export var throw_height_strenght: float = 100.0
@export var throw_starting_height: float = 49

var pick_up: bool = false
var throwable: Node2D
var throw_direction: Vector2
var object_sprite: Sprite2D
var vertical_velocity: float = 0
var ground_height: float = 0
var animation_player: AnimationPlayer

@onready var hurt_box: HurtBox = $Hurt_Box


func _ready():
	area_entered.connect( _on_area_entered )
	area_exited.connect( _on_area_exited )
	throwable = get_parent()
	setup_hurt_box()
	
	object_sprite = throwable.find_child( "Sprite2D" )
	ground_height = object_sprite.position.y
	animation_player = throwable.find_child( "AnimationPlayer" )
	
	set_physics_process( false )
	
	
func _physics_process(delta):
	object_sprite.position.y += vertical_velocity * delta 
	vertical_velocity += gravity_strenght * delta
	throwable.position += throw_direction * throw_speed * delta
	if object_sprite.position.y >= ground_height:
		destroy()
	
func player_interact():
	if PlayerManager.interact_handled == true:
		return
	if throwable.has_method("drop_item"):
		throwable.drop_item()
	if pick_up == false:
		PlayerManager.interact_handled = true
		disabble_collision( throwable )
		if throwable.get_parent():
			throwable.get_parent().remove_child( throwable )
		PlayerManager.player.held_item.add_child( throwable )
		throwable.position = Vector2.ZERO
		PlayerManager.player.pick_up_item( self )
		area_entered.disconnect( _on_area_entered )
		area_exited.disconnect( _on_area_exited )
		pass

func throw():
	throwable.get_parent().remove_child( throwable )
	PlayerManager.player.get_parent().call_deferred( "add_child", throwable )
	throwable.position = PlayerManager.player.position 
	object_sprite.position.y = -throw_starting_height
	vertical_velocity = -throw_height_strenght
	set_physics_process( true)
	hurt_box.set_deferred( "monitoring", true )
	hurt_box.did_damage.connect( destroy )
	
	
func drop():
	throwable.get_parent().remove_child( throwable )
	PlayerManager.player.get_parent().call_deferred( "add_child", throwable )
	throwable.position = PlayerManager.player.position
	object_sprite.position.y = -50
	vertical_velocity = -200
	throw_speed = 100
	set_physics_process( true )
	
func destroy():
	set_physics_process(false)
	
	if animation_player:
		animation_player.play("Destroy")
		await animation_player.animation_finished
	throwable.queue_free()
	
	
func disabble_collision(_node: Node):
	for c in _node.get_children():
		if c == self:
			continue
		if c is CollisionShape2D:
			c.disabled = true
		else:
			disabble_collision( c )

func _on_area_entered(_area:Area2D):
	PlayerManager.interact_pressed.connect( player_interact )
	
func _on_area_exited(_area:Area2D):
	PlayerManager.interact_pressed.disconnect( player_interact )
	
func setup_hurt_box():
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var _col: CollisionShape2D = c.duplicate()
			hurt_box.add_child( _col )
			_col.debug_color = Color(1,0,0,0.5)
