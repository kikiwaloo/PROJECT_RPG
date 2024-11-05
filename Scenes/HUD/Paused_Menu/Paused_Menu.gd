extends CanvasLayer


signal item_selected(slot_data)
signal show
signal hidden
signal add_heart

@onready var slots: InventorySlot = $Control/PanelContainer/GridContainer/InventorySlot
#@onready var item_description = $Control/DescriptionContenaire/Item_Description
@onready var sprite = $Control/HeartContenaire/CenterContainer/Sprite2D
@onready var sound_open = $Control/Sound_open
@onready var sound_close = $Control/Sound_close
@onready var audio = $Control/AudioStreamPlayer
@onready var grid_container = $Control/Weapon_Inventory/GridContainer

var is_paused: bool = false


func _ready():
	hide_pause_menu()
	LevelManager.nb_quarter_heart.connect( quarter_heart )

	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Inventory"):
		if is_paused == false:
			show_pause_menu()
			sound_open.play()
		else :
			hide_pause_menu()
			sound_close.play()
		get_viewport().set_input_as_handled()
			
func show_pause_menu():
	get_tree().paused = true
	visible = true
	is_paused = true
	PlayerHud.visible = false
	show.emit()

func hide_pause_menu():
	get_tree().paused = false
	visible = false
	is_paused = false
	PlayerHud.visible = true
	hidden.emit()

#func update_item_description( new_text: String):
	#item_description.text = new_text
	
func play_audio( _audio : AudioStream ) -> void:
	audio.stream = _audio
	audio.play()
	
func quarter_heart(_nb_quarter):
	if LevelManager.quarter_heart == 1:
		sprite.frame = 1
	elif LevelManager.quarter_heart == 2:
		sprite.frame = 2
	elif LevelManager.quarter_heart == 3:
		sprite.frame = 3
	elif LevelManager.quarter_heart == 4:
		add_heart.emit()
		LevelManager.quarter_heart = 0
	else:
		sprite.frame = 0
		

