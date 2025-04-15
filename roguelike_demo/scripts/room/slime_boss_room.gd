extends BaseRoom

var slime_boss_scene: PackedScene = preload("res://scenes/character/enemy/slime_boss.tscn")

func _ready() -> void:
	super()

func get_enemy_num(sc: Vector2) -> int:
	return int(pow(2, sc.x / 2)) - 1

func spawn_enemies() -> void:
	for point in enemy_spawn_points.get_children():
		var slime_boss = slime_boss_scene.instantiate() as SlimeBoss
		slime_boss.position = point.position
		slime_boss.tree_exited.connect(on_enemy_tree_exit)
		enemy_num = get_enemy_num(slime_boss.scale)
		call_deferred("add_child", slime_boss)
