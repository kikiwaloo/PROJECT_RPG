extends Area2D
class_name DiagObject

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)