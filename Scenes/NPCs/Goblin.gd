extends CharacterBody2D
class_name GoblinNpc

@export var dist:float
@export var speed:float

@onready var pos_data = $Pos_Data

var pos_final: bool = false

func _ready():
	_set_pos_data()
	
func _physics_process(_delta):
	move()
	
	
func move():
	if Dialogue.quest_goblin == true:
		if pos_final == true:
			return
		pos_final = true
		pos_data.set_value()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2.LEFT * dist, speed).as_relative().set_trans(Tween.TRANS_LINEAR)
		Dialogue.quest_goblin = false
	
func _set_pos_data():
	pos_final = pos_data.value
	if pos_final == true:
		global_position = Vector2(739, 367)
	else:
		global_position = Vector2(789, 367)
	pass
	
