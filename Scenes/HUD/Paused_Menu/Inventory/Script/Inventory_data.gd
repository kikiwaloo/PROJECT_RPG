extends Resource
class_name Inventory_Data

@export var weapon_slots: Array[ SlotData ]
@export var potion_slots: Array[ SlotData ]
@export var equipement_slots: Array[ SlotData ]
@export var quest_slots: Array[ SlotData ]


func _init():
	connect_slots()
	connect_potion_slot()
	connect_equipement_slot()
	connect_quest_slot()
	
func add_items(item: ItemData, count: int = 1) -> bool:
	if item.type == item.TYPE.EQUIPEMENT:
		for s in equipement_slots:
			if s : 
				if s.item_data == item:
					#s.quantity += count
					return true
			
		for i in equipement_slots.size():
			if weapon_slots[ i ] == null:
				var new = SlotData.new()
				new.item_data = item
				#new.quantity = count
				equipement_slots[ i ] = new
				new.changed.connect( slot_changed ) 
				return true
				
	if item.type == item.TYPE.WEAPON:
		for s in weapon_slots:
			if s : 
				if s.item_data == item:
					#s.quantity += count
					return true
			
		for i in weapon_slots.size():
			if weapon_slots[ i ] == null:
				var new = SlotData.new()
				new.item_data = item
				#new.quantity = count
				weapon_slots[ i ] = new
				new.changed.connect( slot_changed ) 
				return true
				
	if item.type == item.TYPE.POTION:
		for s in potion_slots:
			if s : 
				if s.item_data == item:
					s.quantity += count
					return true
			
		for i in potion_slots.size():
			if potion_slots[ i ] == null:
				var new = SlotData.new()
				new.item_data = item
				new.quantity = count
				potion_slots[ i ] = new
				new.changed.connect( potion_slots_changed ) 
				return true
				
	if item.type == item.TYPE.QUEST:
		for s in quest_slots:
			if s : 
				if s.item_data == item:
					s.quantity += count
					return true
					
		for i in quest_slots.size():
			if quest_slots[ i ] == null:
				var new = SlotData.new()
				new.item_data = item
				new.quantity = count
				quest_slots[ i ] = new
				new.changed.connect( quest_slots_changed ) 
				return true
				
	return false


func connect_slots():
	for s in weapon_slots:
		if s:
			s.changed.connect( slot_changed )
			
func connect_potion_slot():
	for s in potion_slots:
		if s:
			s.changed.connect( potion_slots_changed )
			
func connect_equipement_slot():
	for s in equipement_slots:
		if s:
			s.changed.connect( equipement_slots_changed )
			
func connect_quest_slot():
	for s in quest_slots:
		if s:
			s.changed.connect( quest_slots_changed )
			
func slot_changed():
	for s in weapon_slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed) 
				var index = weapon_slots.find( s )
				weapon_slots[ index ] = null
				emit_changed()
	pass

func potion_slots_changed():
	for s in potion_slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( potion_slots_changed ) 
				var index = potion_slots.find( s )
				potion_slots[ index ] = null
				emit_changed()
				
func equipement_slots_changed():
	for s in equipement_slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( equipement_slots_changed ) 
				var index = equipement_slots.find( s )
				equipement_slots[ index ] = null
				emit_changed()

func quest_slots_changed():
	for s in quest_slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( quest_slots_changed )
				var index = quest_slots.find( s )
				quest_slots[ index ] = null
				emit_changed()
				
func get_save_data()-> Array:
	var item_save : Array = []
	for i in weapon_slots.size():
		item_save.append( item_to_save( weapon_slots[i] ) )
	return item_save
	
func get_save_potion_data()-> Array:
	var item_save : Array = []
	for i in potion_slots.size():
		item_save.append( item_to_potion_save( potion_slots[i] ) )
	return item_save

func get_save_equipement_data()-> Array:
	var item_save: Array = []
	for i in equipement_slots.size():
		item_save.append( item_to_equipement_save( equipement_slots[i] ))
	return item_save

func get_save_quest_data()-> Array:
	var item_save: Array = []
	for i in quest_slots.size():
		item_save.append( item_to_quest_save( quest_slots[i] ))
	return item_save
	
func item_to_save( slot: SlotData)-> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
			
	return result
	
func item_to_potion_save( slot: SlotData)-> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
			
	return result

func item_to_equipement_save( slot: SlotData)-> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func item_to_quest_save( slot: SlotData)-> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result
	
func parse_save_data( save_data: Array):
	var array_size = weapon_slots.size()
	weapon_slots.clear()
	weapon_slots.resize( array_size )
	for i in save_data.size():
		weapon_slots[ i ] = item_from_save( save_data[ i ] )
	connect_slots()
	
func parse_save_potion_data(save_data: Array):
	var array_size = potion_slots.size()
	potion_slots.clear()
	potion_slots.resize( array_size )
	for i in save_data.size():
		potion_slots[ i ] = item_from_save( save_data[ i ] )
	connect_potion_slot()
	
func parse_save_equipement_data(save_data: Array):
	var array_size = equipement_slots.size()
	equipement_slots.clear()
	equipement_slots.resize( array_size )
	for i in save_data.size():
		equipement_slots[ i ] = item_from_save( save_data[ i ] )
	connect_equipement_slot()

func parse_save_quest_data(save_data: Array):
	var array_size = quest_slots.size()
	quest_slots.clear()
	quest_slots.resize( array_size )
	for i in save_data.size():
		quest_slots[ i ] = item_from_save( save_data[ i ])
	connect_quest_slot()
	
func item_from_save( save_object: Dictionary)-> SlotData:
	if save_object.item == "":
		return null
	var new_slot = SlotData.new()
	new_slot.item_data = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot
		
