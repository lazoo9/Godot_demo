class_name C_Inventory
extends Node

# 背包槽大小
var MAX_SLOT_SIZE = 20
@export var Items: Array[Item] = []
# 道具变化时发出的信号
signal items_change

func _ready() -> void:
	Items.resize(MAX_SLOT_SIZE)

func get_empty_index() -> int:
	var size = len(Items)
	for i in range(size):
		if Items[i] == null:
			return i
	return -1

func add_item(item: Item) -> bool:
	var empty_index = get_empty_index()
	if empty_index == -1:
		return false
	Items[empty_index] = item
	items_change.emit()
	return true

func delete_item(index: int) -> void:
	if Items[index] != null:
		Items[index] = null
		items_change.emit()

func get_item(index: int) -> Item:
	return Items[index]

func packet_items() -> void:
	merge_similar_items()
	sort_items_by_type()
	items_change.emit()

func merge_similar_items() -> void:
	var tmp_items = Items.duplicate()
	var size = len(tmp_items)
	for i in range(size):
		if Items[i] == null or Items[i].is_max_quantity():
			continue
		for j in range(i+1, size):
			if Items[j] != null and Items[j].can_item_merge(Items[j]):
				Items[i].merge_quantity(Items[j])
				if Items[j].quantity <= 0:
					Items[j] = null
	Items = tmp_items.filter(func(i): return i != null)
	Items.resize(MAX_SLOT_SIZE)

func sort_items_by_type() -> void:
	var tmp_items = Items.duplicate()
	var size = len(tmp_items)
	tmp_items = tmp_items.filter(func(i): return i != null)
	tmp_items.sort_custom(
		func(a, b):
			return a.category < b.category
	)
	Items = tmp_items
	Items.resize(MAX_SLOT_SIZE)
