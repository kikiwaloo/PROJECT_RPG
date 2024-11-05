extends Control
class_name SplashScreenManager


@export var _move_to: PackedScene

@export var _initial_delay: float = 1

var _splash_screens: Array[SplashScreen] = []

@onready var splash_screen_contenaire = $Control

func _ready() -> void:
	
	PlayerManager.player.visible = false
	PlayerHud.visible = false
	PausedMenu.process_mode = Node.PROCESS_MODE_DISABLED
	MenuPause.process_mode = Node.PROCESS_MODE_DISABLED
	PlayerManager.player.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	assert(_move_to)

	set_process_input(false)

	for splash_screen in splash_screen_contenaire.get_children():
		splash_screen.hide()
		_splash_screens.push_back(splash_screen)

	await get_tree().create_timer(_initial_delay).timeout

	_start_splash_screen()

	set_process_input(true)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		_skip()


func _start_splash_screen() -> void:
	if _splash_screens.size() == 0:
		get_tree().change_scene_to_packed(_move_to)
	else:
		var splash_screen: SplashScreen = _splash_screens.pop_front()
		splash_screen.start()
		splash_screen.connect("finished", _start_splash_screen)


func _skip() -> void:
	splash_screen_contenaire.get_child(0).queue_free()
	_start_splash_screen()
