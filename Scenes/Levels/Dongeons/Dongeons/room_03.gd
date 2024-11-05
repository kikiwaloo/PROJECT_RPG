extends Level
class_name Room03


signal position_changed

@onready var data_position = $Data_position
@onready var object = $Pushable_Statue

var obj_in_map : bool = false
var _position: bool = false



func _ready():
	super._ready()
	data_position.data_loaded.connect( _on_set_position )
	object.position_changed.connect( _on_position_changed )
	find_object_in_map()
	_on_set_position()
	print(object.global_position)
	
func find_object_in_map():
	if object:
		obj_in_map = true
		object.set_current_position(object.current_position)
		print(object.name)
		
		
func _on_set_position():
	_position = data_position.value
	if _position:
		object.global_position = object.position
		print("new_pos-" + str(object.new_pos))


func _on_position_changed():
	if object.current_position != object.new_pos:
		_position = true
		data_position.set_value()
		object.new_pos = object.current_position
		print("new_pos_ " + str(object.new_pos))

