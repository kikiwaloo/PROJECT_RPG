extends CanvasLayer
class_name RealPausedMenu


@onready var button = $Control/PanelContainer/VBoxContainer/Save

var pause_visible: bool = false

func _ready():
	for _button in get_tree().get_nodes_in_group("Buttons"):
		_button.pressed.connect( _on_button_pressed.bind(_button))
		
	set_paused_invisible()
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		if pause_visible == false:

			set_paused_visible()
			button.grab_focus()
		else:
			set_paused_invisible()
		get_viewport().set_input_as_handled()

func set_paused_visible():
	get_tree().paused = true
	visible = true
	pause_visible = true
	
func set_paused_invisible():
	get_tree().paused = false
	visible = false
	pause_visible = false

func _on_button_pressed(_button: Button):
	match _button.name:
		"Save":
			if pause_visible == false:
				return
			SaveManager.save_game()
			set_paused_invisible()
		
		"Load":
			if pause_visible == false:
				return
			SaveManager.load_game()
			await LevelManager.level_load_started
			set_paused_invisible()
			
		"Quit":
			get_tree().quit()
	
