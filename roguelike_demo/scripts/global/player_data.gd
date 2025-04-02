extends Node

var max_hp: int = 4
var cur_hp: int = 0
var weapons: Array[Weapon] = [preload("res://scenes/weapon/sword.tscn").instantiate()]
var cur_weapon_index: int = 0

func _init() -> void:
	cur_hp = max_hp
