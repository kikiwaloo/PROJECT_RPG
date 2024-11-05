extends Node2D
class_name Panneaux


@onready var actionable_panel = $Actionable_panel
@onready var panel = $Control/Panel

var is_panel_visible: bool = false
var intercat:bool = false

func _ready():
	set_paused_invisible()
	
func _unhandled_input(event: InputEvent):
	if intercat == true:
		if event.is_action_pressed("Interact"):
			if is_panel_visible == false:
				set_paused_visible()
			else:
				set_paused_invisible()
			get_viewport().set_input_as_handled()

func set_paused_visible():
	get_tree().paused = true
	panel.visible = true
	is_panel_visible = true
	
func set_paused_invisible():
	get_tree().paused = false
	panel.visible = false
	is_panel_visible = false
	

func _on_actionable_panel_area_entered(_area):
	intercat = true
	pass # Replace with function body.


func _on_actionable_panel_area_exited(_area):
	intercat = false
 
	pass # Replace with function body.
