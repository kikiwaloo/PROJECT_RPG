extends Node2D

@export var object_map: Object1_Mapping

@export var tile_map: TileMap:
	set(new_tile_map):
		tile_map = new_tile_map
		create_objects()
@export var object_layer_name = "objects1"
@export var cell_size = 32


func create_objects():
	var tile_id = get_tile_id()
	var layer_id = get_objects_layer()
	for cell_pos in tile_map.get_used_cells_by_id(layer_id, tile_id):
		var obj_id = tile_map.get_cell_atlas_coords(layer_id, cell_pos).x
		add_object_by_id(cell_pos, obj_id)
	tile_map.clear_layer(layer_id)
	
func add_object_by_id(pos, id):
	var map = object_map.mapping
	if map.has(id):
		var mapping = map.get(id)
		if mapping.has("scene"):
			var scene = mapping.get("scene")
			var new_obj = scene.instantiate()
			new_obj.position = pos * cell_size 
			add_child(new_obj)
	
func get_objects_layer():
	for layer_id in range(tile_map.get_layers_count()):
		if tile_map.get_layer_name(layer_id) == object_layer_name:
			return layer_id
	
	
func get_tile_id():
	var tile_set = tile_map.tile_set
	for index in range(tile_set.get_source_count()):
		var id = tile_set.get_source_id(index)
		if tile_set.get_source(id).resource_name == object_layer_name:
			return id
