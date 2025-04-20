extends Node

const file_path: String = "user://player_data.dat"

var max_hp: int = 4
var cur_hp: int = 0
var weapons: Array = ["res://scenes/weapon/sword.tscn"]
var cur_weapon_index: int = 0
var level: int = 5

func _init() -> void:
	cur_hp = max_hp

func reset() -> void:
	clear_weapons()
	max_hp = 4
	cur_hp = max_hp
	weapons = ["res://scenes/weapon/sword.tscn"]
	cur_weapon_index = 0
	level = 1

func clear_weapons() -> void:
	weapons.clear()

func to_dict() -> Dictionary:
	return {
		"max_hp" = max_hp,
		"cur_hp" = cur_hp,
		"weapons" = weapons,
		"cur_weapon_index" = cur_weapon_index,
		"level" = level
	}

func from_dict(dict: Dictionary) -> void:
	max_hp = dict["max_hp"]
	cur_hp = dict["cur_hp"]
	weapons = dict["weapons"]
	cur_weapon_index = dict["cur_weapon_index"]
	level = dict["level"]

func save_to_file() -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var dict = to_dict()
		var context = JSON.stringify(dict)
		file.store_string(context)
	else:
		push_error("open player data file error")

func load_from_file() -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var context = file.get_as_text()
		var dict = JSON.parse_string(context)
		from_dict(dict)
	else:
		push_error("open player data file error")
