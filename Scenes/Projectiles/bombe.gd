extends Node2D
class_name Bombe


@onready var animation_player = $AnimationPlayer

enum State {PLANT, EXPLOSE}

var player: Player
var state

func _ready():
	visible = false
	player = PlayerManager.player
	pass


func plant_bombe():
	state = State.PLANT
	visible = true
	LevelManager.set_nb_bombe( LevelManager.nb_bombe -1)
	animation_player.play("As_Explose")
	await animation_player.animation_finished
	if LevelManager.nb_bombe == 0:
		VariablesWeapons.bombe = false
	bombe_explose()

func bombe_explose():
	state = State.EXPLOSE
	animation_player.play("Destroy")
	await animation_player.animation_finished
	queue_free()
