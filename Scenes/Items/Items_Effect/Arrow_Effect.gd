extends ItemsEffect
class_name ArrowEffect

@export var audio_take: AudioStream
@export var audio_use: AudioStream
@export var quantity: int = 1
@export var price: int = 1


func take():
	LevelManager.set_nb_arrows( LevelManager.nb_arrows +1)
	VariablesWeapons.arrows = true
	PausedMenu.play_audio( audio_take )


func use():
	LevelManager.set_nb_arrows(LevelManager.nb_arrows -1)
	PausedMenu.play_audio( audio_use )
	if LevelManager.nb_arrows == 0:
		VariablesWeapons.arrows = false
	
func shop_take():
	VariablesWeapons.arrows = true
	LevelManager.set_nb_coin(LevelManager.nb_coins - price )
	LevelManager.set_nb_arrows(LevelManager.nb_arrows + quantity)
	
