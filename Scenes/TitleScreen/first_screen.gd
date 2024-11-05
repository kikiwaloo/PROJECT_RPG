extends Control
class_name FirstScreen

var TITLE = preload("res://Scenes/TitleScreen/title_screen.tscn")

@onready var timer_change_scene = $Timer_Change_Scene
@onready var timer_logo = $Timer_Logo
@onready var k_logo = $KLogo
@onready var label = $Label
@onready var audio = $AudioStreamPlayer



func _ready():
	timer_logo.timeout.connect( _on_timer_logo_timeout )
	timer_change_scene.timeout.connect( _on_timer_timeout )
	k_logo.visible = false
	label.visible = false
	PlayerHud.visible = false
	
func _on_timer_timeout():
	get_tree().change_scene_to_packed(TITLE)

func _on_timer_logo_timeout():
	k_logo.visible = true
	audio.play()
	label.visible = true
	timer_change_scene.start()
	pass
