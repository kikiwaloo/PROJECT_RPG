extends Level



@onready var collision = $Area2D/CollisionShape2D


func _ready():
	super()
	
func _process(_delta):
	active_collision()
	
	
func active_collision():
	if VariablesWeapons.active_lantern == true:
		collision.disabled = true
	elif VariablesWeapons.active_lantern == false:
		collision.disabled = false

	


