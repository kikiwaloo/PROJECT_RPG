extends Control
class_name ControlMenu

@onready var button = $Button
@export var music: AudioStream

func _ready():
	button.grab_focus()
	button.pressed.connect( _on_button_pressed )
	AudioManager.play_music( music )
	
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/TitleScreen/main_menu.tscn")
