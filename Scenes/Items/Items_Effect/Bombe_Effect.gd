extends ItemsEffect
class_name Bombe_Effect

@export var audio_take: AudioStream
@export var audio_use: AudioStream
@export var quantity: int = 1
@export var price: int = 1


func take():
	LevelManager.set_nb_bombe( LevelManager.nb_bombe +1)
	VariablesWeapons.bombe = true
	PausedMenu.play_audio( audio_take )

		
func use():
	LevelManager.set_nb_bombe(LevelManager.nb_bombe -1)
	PausedMenu.play_audio( audio_use )
	if LevelManager.nb_bombe == 0:
		VariablesWeapons.bombe = false
	
func shop_take():
	VariablesWeapons.bombe = true
	LevelManager.set_nb_coin(LevelManager.nb_coins - price )
	LevelManager.set_nb_bombe(LevelManager.nb_bombe + quantity)
