extends Node

var max_hp: int = 4
var cur_hp: int = 0
var weapons: Array[Weapon] = [preload("res://scenes/weapon/sword.tscn").instantiate()]
var cur_weapon_index: int = 0
var level: int = 1

func _init() -> void:
	cur_hp = max_hp

func reset() -> void:
	max_hp = 4
	cur_hp = max_hp
	weapons = [preload("res://scenes/weapon/sword.tscn").instantiate()]
	cur_weapon_index = 0
	level = 1

func clear_weapons() -> void:
	for weapon in weapons:
		weapon.queue_free()
