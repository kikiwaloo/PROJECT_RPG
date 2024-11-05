extends Node2D
class_name PressurPlate

signal activated
signal desactivated

var bodies:int = 0
var is_active: bool = false
var off_rect: Rect2

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer2D
@onready var audio_activate: AudioStream = preload("res://Art/Audio/lever-01.wav")
@onready var audio_desactivate: AudioStream = preload("res://Art/Audio/lever-02.wav")


func _ready():
	area.body_entered.connect( _on_body_entered )
	area.body_exited.connect( _on_body_exited )
	off_rect = sprite.region_rect
	
	
	
	
func _on_body_entered(_body: Node2D):
	bodies += 1
	check_is_activated()
	
	
func _on_body_exited(_body: Node2D):
	bodies -= 1
	check_is_activated()



func check_is_activated():
	if bodies > 0 and is_active == false:
		is_active = true
		sprite.region_rect.position.x = off_rect.position.x - 32
		play_audio( audio_activate )
		activated.emit()
		
	elif bodies <= 0 and is_active == true:
		is_active = false
		sprite.region_rect.position.x = off_rect.position.x
		play_audio( audio_desactivate )
		desactivated.emit()

func play_audio( _stream: AudioStream):
	audio.stream = _stream
	audio.play()
