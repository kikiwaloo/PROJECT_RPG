extends Resource
class_name DropData

@export var item: ItemData
@export_range( 0, 100, 1, "suffix:%" ) var probabitity: float = 100.0
@export_range( 1, 10, 1, "suffix:item") var min_amount: int = 1
@export_range( 1, 10, 1, "suffix:item") var max_amount: int = 1

func get_drop_item()-> int:
	if randf_range( 0, 100 ) >= probabitity:
		return 0
	return randi_range( min_amount, max_amount )
