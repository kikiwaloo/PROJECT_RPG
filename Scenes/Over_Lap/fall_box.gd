extends Area2D
class_name FallBox

signal fall_damaged(hurt_box: HoleTrap)


func take_damage(hurt_box: HoleTrap):
	fall_damaged.emit(hurt_box)


