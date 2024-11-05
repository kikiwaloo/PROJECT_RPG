extends ItemsEffect
class_name ItemEffectHeal

@export var heal_amount: int = 1
@export var audio: AudioStream
@export var price: int = 1
@export var audio_shop_take: AudioStream

func use():
	PlayerManager.player.update_hp( heal_amount )
	PausedMenu.play_audio( audio )

func take():
	pass

func shop_take():
	LevelManager.set_nb_coin(LevelManager.nb_coins - price)
	PausedMenu.play_audio( audio_shop_take )
