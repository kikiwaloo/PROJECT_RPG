extends Control
class_name SecondScreen

@export var time: float = 3
@export var fade_time: float = 1


signal finished()

func start():
	modulate.a = 0
	show()
	var tween = create_tween()
	tween.connect("finished", finish)
	tween.tween_property(self, "modulate:a", 1 , fade_time)
	tween.tween_interval(time)
	tween.tween_property(self, "modulate:a", 0, fade_time)


func finish():
	finished.emit()
	queue_free()
