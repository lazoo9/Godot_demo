extends Node

const file_path: String = "user://player_data.dat"

var max_hp: int = 4
var cur_hp: int = 0
var max_energy: float = 2.0
var cur_energy: float = 0.0
var weapons: Array = ["res://scenes/weapon/sword_2.tscn"]
var cur_weapon_index: int = 0
var level: int = 5
var activated_skills: Array = []
var can_heavy_attack: bool = false
var skill_point_num: int = 0:
	set(value):
		skill_point_num = value
		skill_point_num_changed.emit(skill_point_num)

signal skill_point_num_changed(num: int)

func _init() -> void:
	cur_hp = max_hp
	cur_energy = max_energy

func reset() -> void:
	clear_weapons()
	max_hp = 4
	cur_hp = max_hp
	max_energy = 2.0
	cur_energy = max_energy
	weapons = ["res://scenes/weapon/sword_2.tscn"]
	cur_weapon_index = 0
	level = 1
	activated_skills = []
	can_heavy_attack = false
	skill_point_num = 0

func clear_weapons() -> void:
	weapons.clear()

func to_dict() -> Dictionary:
	return {
		"max_hp" = max_hp,
		"cur_hp" = cur_hp,
		"max_energy" = max_energy,
		"cur_energy" = cur_energy,
		"weapons" = weapons,
		"cur_weapon_index" = cur_weapon_index,
		"level" = level,
		"activated_skills" = activated_skills,
		"can_heavy_attack" = can_heavy_attack,
		"skill_point_num" = skill_point_num
	}

func from_dict(dict: Dictionary) -> void:
	max_hp = dict["max_hp"]
	cur_hp = dict["cur_hp"]
	max_energy = dict["max_energy"]
	cur_energy = dict["cur_energy"]
	weapons = dict["weapons"]
	cur_weapon_index = dict["cur_weapon_index"]
	level = dict["level"]
	activated_skills = dict["activated_skills"]
	can_heavy_attack = dict["can_heavy_attack"]
	skill_point_num = dict["skill_point_num"]

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
