extends Node2D
class_name BaseRoom

@onready var ground: TileMapLayer = $Tiles/Ground
@onready var wall: TileMapLayer = $Tiles/Wall
@onready var entry_points: Node2D = $EntryPoints
@onready var doors: Node2D = $Doors
@onready var player_detector: Area2D = $PlayerDetector
@onready var enemy_spawn_points: Node2D = $EnemySpawnPoints
@onready var parent = get_parent()

var enemy_spawn_effect: PackedScene = preload("res://scenes/effect/enemy_spawn_effect.tscn")
var enemy_scene: PackedScene = preload("res://scenes/character/enemy/flying_creature.tscn")
@export var enemy_num: int = 2

func _ready() -> void:
	enemy_num = enemy_spawn_points.get_child_count()
	if enemy_num == 0:
		open_doors()

func spawn_enemies() -> void:
	for point in enemy_spawn_points.get_children():
		var spawn_effect = enemy_spawn_effect.instantiate()
		spawn_effect.global_position = point.global_position
		parent.add_child(spawn_effect)
		spawn_effect.tree_exited.connect(enemy_spawn.bind(point.global_position))

func close_entrance() -> void:
	for point in entry_points.get_children():
		var pos = wall.local_to_map(to_local(point.global_position))
		wall.set_cell(pos, 0, Vector2i(2, 6), 0)
		ground.set_cell(pos + Vector2i(0, 1), 0, Vector2i(7, 4), 0)

func open_doors() -> void:
	for door in doors.get_children():
		door.open()

func enemy_spawn(pos: Vector2) -> void:
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.global_position = pos
	enemy.tree_exited.connect(on_enemy_tree_exit)
	parent.add_child(enemy)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		if enemy_num > 0:
			spawn_enemies()
		else:
			open_doors()
		close_entrance()
	player_detector.queue_free()

func on_enemy_tree_exit() -> void:
	enemy_num -= 1
	if enemy_num <= 0:
		open_doors()
