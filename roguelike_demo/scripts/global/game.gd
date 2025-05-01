extends Node

var player: Player

var weapon_list: Array[PackedScene] = [
	preload("res://scenes/weapon/hammer.tscn"),
	preload("res://scenes/weapon/sword_2.tscn")
]

func save_data() -> void:
	player.save_data()

func load_data() -> void:
	player.load_data()
