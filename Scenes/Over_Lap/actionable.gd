extends Area2D
class_name Actionable


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

signal start_diag()
signal finish_diag()

func action():
	start_diag.emit()
	DialogueManager.finish.connect( _on_dialogue_finished )
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_dialogue_finished():
	DialogueManager.finish.disconnect( _on_dialogue_finished )
	finish_diag.emit()
