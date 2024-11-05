extends PointLight2D





func _ready():
	flicker()
	
func _process(_delta):
	if VariablesWeapons.active_lantern == true:
		visible = true
	else:
		visible = false

func flicker():
	energy = randf() * 0.1 + 0.9
	scale = Vector2(1,1) * energy
	await get_tree().create_timer(0.1332).timeout
	flicker()
