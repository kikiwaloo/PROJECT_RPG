extends HurtBox
class_name Projectile

@export var speed = 400.0
@onready var direction := Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float):
	var velocity = direction * speed * delta
	global_position += velocity


func _on_area_entered(area: Area2D):
	super._on_area_entered(area)
	queue_free()

