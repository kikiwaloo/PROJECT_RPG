extends Resource
class_name ItemData


enum TYPE {OBJECT,WEAPON,POTION,HP,EQUIPEMENT,QUEST}

@export var type: TYPE
@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
@export var value: int = 1

@export_category("Item Use Effects")
@export var effects: Array[ ItemsEffect ]



func use()-> bool:
	if effects.size() == 0:
		return false
		
	for e in effects:
		if e:
			e.use()
	return true

func take()-> bool:
	if effects.size() == 0:
		return false
		
	for e in effects:
		if e:
			e.take()
	return true

func shop_take()-> bool:
	if effects.size() == 0:
		return false
		
	for e in effects:
		if e:
			e.shop_take()
	return true
