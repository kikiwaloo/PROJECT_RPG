extends ItemsEffect
class_name PendentifEffect

@export var amount: int = 1
@export var audio_take: AudioStream
@export var audio_use: AudioStream

func take():
	Dialogue.present = true
	PausedMenu.play_audio( audio_take )
	print(Dialogue.present)
	
func use():
	PausedMenu.play_audio(audio_use)
