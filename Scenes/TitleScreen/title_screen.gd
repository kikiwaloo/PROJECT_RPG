extends Node2D
class_name TitleScreen


@onready var animation_player = $AnimationPlayer
@onready var label = $Label
@onready var audio = $AudioStreamPlayer
@onready var title = $Title
@onready var sword = $Sword
@onready var background = $TextureRect

var start: bool = false

func _ready():
	
	audio.play()
	PlayerHud.visible = false
	label.visible = false
	animation()
	pass
	
func animation():

	animation_player.play("title_appear")
	await animation_player.animation_finished
	
	animation_player.play("sword_appear")
	await animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	
	label.visible = true
	animation_player.play("Start_Anim")
	start = true
	
func _input(event):
	if start == true:
		if event.is_action_pressed("Start"):
			get_tree().change_scene_to_file("res://Scenes/TitleScreen/main_menu.tscn")
			
