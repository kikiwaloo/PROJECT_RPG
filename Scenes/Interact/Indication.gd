extends Panel
class_name Indication


func _process(_delta):
	if LevelManager.is_panel_visible == true:
		visible = true
	else :
		visible = false
