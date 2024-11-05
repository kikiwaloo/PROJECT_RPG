extends Node2D
class_name Level


@export var music: AudioStream

func _ready():
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level)
	LevelManager.actor_died.connect( _on_actor_died )
	AudioManager.play_music( music )

func _free_level():
	PlayerManager.unparent_player( self)
	queue_free()

func _on_actor_died(actor: Enemy):
	var enemies_array = get_tree().get_nodes_in_group("Enemy")
	if enemies_array == [actor]:
		LevelManager.room_finished.emit()

