extends Node

var Items: Array[Item] = []

signal items_changed

func add_item(item) -> void:
	pass

func delete_item(index: int) -> void:
	pass

func get_item(index: int) -> Item:
	return Items[index]

func update_dislay() -> void:
	pass
