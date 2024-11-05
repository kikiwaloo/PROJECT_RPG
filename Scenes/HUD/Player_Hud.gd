extends CanvasLayer


var hearts: Array[ HeartGui ] = []

@onready var nb_rupees = $Control/Rupee/Nb_Rupees
@onready var nb_arrow = $Control/Arrow/Nb_Arrow
@onready var nb_keys = $Control/KeyHud/Nb_Keys
@onready var magie_bar = $Control/TextureProgressBar
@onready var nb_bombe = $Control/Bombe/Nb_Bombe

signal objet_collected(item_data)

func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGui:
			hearts.append( child )
			child.visible = false
			
	LevelManager.nb_coin_changed.connect(_on_nb_coins_changed )
	LevelManager.nb_key_changed.connect( _on_nb_keys_changed )
	LevelManager.nb_arrows_changed.connect( _on_nb_arrows_changed )
	LevelManager.mp_changed.connect( _on_mp_changed )
	LevelManager.nb_bombe_changed.connect( _on_nb_bombe_changed )
	pass # Replace with function body.

func update_hp(hp:int, max_hp: int):
	update_max_hp( max_hp)
	
	@warning_ignore("integer_division")
	var max_heart = max_hp/2
	for i in max_heart:
		update_heart( i, hp)
		pass
	pass

func update_heart(_index: int, _hp: int):
	var _value = clampi( _hp - _index * 2, 0, 2)
	hearts[ _index ].value = _value

	
func update_max_hp(_max_hp):
	var heart_count = roundi( _max_hp * 0.5)
	for i in hearts.size():
		if i < heart_count:
			hearts[i].visible = true
		else :
			hearts[i].visible = false
		
		
func _on_nb_coins_changed(nb_coins: int):
	nb_rupees.set_text("00" + str(nb_coins))
	
	if nb_coins >= 10:
		nb_rupees.set_text("0" + str(nb_coins))
	if nb_coins >= 99:
		nb_rupees.set_text(str(nb_coins))

func _on_nb_keys_changed(_nb_keys: int):
	nb_keys.set_text("0" + str(_nb_keys))

func _on_nb_arrows_changed(_nb_arrows: int):
	nb_arrow.set_text("0" + str( _nb_arrows ))
	if _nb_arrows >= 10:
		nb_arrow.set_text(str(_nb_arrows))

func _on_mp_changed(mp: int):
	magie_bar.set_value( mp )

func _on_nb_bombe_changed(_nb_bombe: int):
	nb_bombe.set_text("0" + str( _nb_bombe ))
	if _nb_bombe >= 10:
		nb_bombe.set_text(str(_nb_bombe))
