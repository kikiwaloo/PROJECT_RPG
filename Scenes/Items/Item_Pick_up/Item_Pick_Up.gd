@tool
extends CharacterBody2D
class_name ItemPickUp

@export var item_data: ItemData: set = _set_item_data

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var audio_stream_player = $AudioStreamPlayer2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var one_shoot_item = $One_Shoot_Item

var one_shoot: bool = false

func _ready():
	update_texture()
	if Engine.is_editor_hint():
		return
	area.body_entered.connect( _on_body_entered )
	_on_set_data_value()
	
func _physics_process(delta):
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal())
	velocity -= velocity * delta * 4
	
func _on_body_entered(b ):
	if b is Player:
		if item_data.type == item_data.TYPE.OBJECT:
			item_data.take()
			item_picked_up()
			if item_data.name == "Quarter_Heart":
				if one_shoot == true:
					return
				one_shoot = true
				one_shoot_item.set_value()
				
		elif item_data.type == item_data.TYPE.HP:
			item_data.use()
			item_picked_up()
		else :
			if PlayerManager.INVENTORY_DATA.add_items( item_data) == true:
				item_data.take()
				item_picked_up()
				if item_data.type == item_data.TYPE.QUEST:
					if one_shoot == true:
						return
					one_shoot = true
					one_shoot_item.set_value()
	pass


func item_picked_up():
	area.body_entered.disconnect( _on_body_entered )
	#audio_stream_player.play()
	visible = false
	await audio_stream_player.finished
	queue_free()
	pass
	
	
func _set_item_data(value: ItemData):
	item_data = value
	update_texture()
	pass
	
func update_texture():
	if item_data and sprite:
		sprite.texture = item_data.texture
	pass


func _on_timer_timeout():
	if item_data.name == "Quarter_Heart":
		timer.stop()
	elif item_data.name == "Key":
		timer.stop()
	elif item_data.name == "Pendentif":
		timer.stop()
	elif item_data.name == "Big_Key":
		timer.stop()
	else:
		animation_player.play("Delete")
		await  animation_player.animation_finished
		queue_free()

func _on_set_data_value():
	one_shoot = one_shoot_item.value
	if one_shoot:
		self.queue_free()
		
