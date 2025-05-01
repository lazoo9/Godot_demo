extends BaseRoom

@onready var weapon_spawn_point: Node2D = $WeaponSpawnPoint

func _ready() -> void:
	super()
	spawn_weapon()

func spawn_weapon() -> void:
	for point in weapon_spawn_point.get_children():
		var index = randi_range(0, Game.weapon_list.size() - 1)
		var weapon: Weapon = Game.weapon_list[index].instantiate()
		weapon.is_on_floor = true
		Game.weapon_list.remove_at(index)
		weapon.global_position = point.global_position
		add_child(weapon)
