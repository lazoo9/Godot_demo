extends Node2D

@export var world_size: Vector2 = Vector2(40, 25)
@export var tile_map_layer: TileMapLayer
@export var collection_scenes: Array[PackedScene] = [
	preload("res://source/actor/collection/collection_tree.tscn")
]
@export var max_collection_alive_num: int = 10
var world_rect: Rect2i:
	set(value):
		world_rect = value
		a_star.region = value
		a_star.update()
var a_star: AStarGrid2D = AStarGrid2D.new()

func _ready() -> void:
	a_star.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	a_star.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	a_star.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	create_world()
	genarate_collection()

func create_world() -> void:
	for i in range(world_size.x):
		for j in range(world_size.y):
			var cell = Vector2(i, j)
			if (i+j) & 1 == 0:
				tile_map_layer.set_cell(cell, 0, Vector2(0, 0))
			else:
				tile_map_layer.set_cell(cell, 0, Vector2(1, 0))
	world_rect = Rect2i(Vector2i.ZERO, world_size)

func genarate_collection() -> void:
	if get_tree().get_node_count_in_group("Collection") < max_collection_alive_num:
		var collection: Collection = collection_scenes.pick_random().instantiate() as Collection
		var pos = get_random_position()
		collection.position = tile_map_layer.map_to_local(pos)
		tile_map_layer.add_child(collection)
		a_star.set_point_solid(pos, true)
	await get_tree().create_timer(1).timeout
	genarate_collection()

func get_random_position() -> Vector2i:
	var cell = Vector2i(
		randi_range(world_rect.position.x, world_rect.size.x),
		randi_range(world_rect.position.y, world_rect.size.y)
	)
	if a_star.is_point_solid(cell):
		cell = get_random_position()
	return cell
