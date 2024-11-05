extends Control


@onready var label = $Label
@onready var button = $ButtonContenaire/Continue
@onready var last_save = $ButtonContenaire/Last_Save


@export var music: AudioStream


func _ready():
	for _button in get_tree().get_nodes_in_group("Buttons"):
		_button.pressed.connect( _on_button_pressed.bind(_button))
		
	last_save.grab_focus()
	move_title()
	AudioManager.play_music( music )
	SceneTransition.fade_in()
	PlayerHud.visible = false
	
	if VariablesWeapons.resurection_potion == true:
		button.disabled = false
	else:
		button.disabled = true
		
func move_title():
	var tween = create_tween()
	tween.tween_property(label, "position", Vector2.LEFT * 580,1.2).as_relative().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "position", Vector2.RIGHT * 56,0.5).as_relative().set_trans(Tween.TRANS_SPRING)

func show_arrow():
	pass

func _on_button_pressed(_button: Button):
	match _button.name:
		"Last_Save":
			SaveManager.load_game()
			PlayerManager.add_player_instance()
			
		"Continue":
			SaveManager.load_game()
			PlayerManager.add_player_instance()

		"Quit":
			get_tree().quit()
		
		
