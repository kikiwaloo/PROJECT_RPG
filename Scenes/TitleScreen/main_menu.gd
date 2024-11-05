extends Control
class_name MainMenu

const start_level = "res://Scenes/Levels/World/00.tscn"

@onready var button = $VBoxContainer/Start
@onready var control = $VBoxContainer/Control
@onready var load_button = $VBoxContainer/Load

@export var music: AudioStream

func _ready():

	AudioManager.play_music( music )
	for _button in get_tree().get_nodes_in_group("Buttons"):
		_button.pressed.connect( _on_button_pressed.bind(_button))
		
	button.grab_focus()
	
	if SaveManager.get_save_file() == null:
		load_button.disabled = true
		load_button.visible = false
		
	LevelManager.level_load_started.connect( exit_title_screen )
	
	
func _on_button_pressed(_button: Button):
	match _button.name:
		"Start":
			PlayerManager.player_spawner = false
			LevelManager.load_new_level(start_level, "", Vector2.ZERO)

		"Load":
			SaveManager.load_game()

		"Control":
			get_tree().change_scene_to_file("res://Scenes/TitleScreen/control_menu.tscn")
			
		"Quit":
			get_tree().quit()


func exit_title_screen():
	PlayerHud.visible = true
	PlayerManager.player.visible = true
	PausedMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	MenuPause.process_mode = Node.PROCESS_MODE_ALWAYS
	PlayerManager.player.process_mode = Node.PROCESS_MODE_PAUSABLE
	self.queue_free()

