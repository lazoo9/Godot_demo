class_name C_Inventory
extends Node

# 背包槽大小
var MAX_SLOT_SIZE = 20
@export var Items: Array[Item] = []
# 道具变化时发出的信号
signal item_change

func _ready() -> void:
	Items.resize(MAX_SLOT_SIZE)

func get_empty_index() -> int:
	var size = len(Items)
	for i in range(size):
		if Items[i] == null:
			return i
	return -1

func get_items_size() -> int:
	return len(Items)

func add_item(item: Item) -> bool:
	var empty_index = get_empty_index()
	if empty_index == -1:
		return false
	Items[empty_index] = item
	item_change.emit()
	return true

func delete_item(index: int) -> void:
	if Items[index] != null:
		Items[index] = null
		item_change.emit()

func get_item(index: int) -> Item:
	return Items[index]

# 获取相同种类的物品
func get_similar_category_items(category: int) -> Array[Item]:
	var tmp_items = Items.duplicate()
	if category == 0:
		return tmp_items
	var filter_items: Array[Item] = tmp_items.filter(
		func(i):
			if i == null: return false
			return i.category == category
	)
	filter_items.resize(MAX_SLOT_SIZE)
	return filter_items

# 整理物品
func packet_items() -> void:
	merge_similar_items()
	sort_items_by_categoty()
	item_change.emit()

func merge_similar_items() -> void:
	var tmp_items = Items.duplicate()
	var size = len(tmp_items)
	for i in range(size):
		if tmp_items[i] == null or tmp_items[i].is_max_quantity():
			continue
		for j in range(i+1, size):
			if tmp_items[j] != null and tmp_items[j].can_item_merge(tmp_items[j]):
				tmp_items[i].merge_quantity(tmp_items[j])
				if tmp_items[j].quantity <= 0:
					tmp_items[j] = null
	Items = tmp_items.filter(func(i): return i != null)
	Items.resize(MAX_SLOT_SIZE)

func sort_items_by_categoty() -> void:
	var tmp_items = Items.duplicate()
	var size = len(tmp_items)
	tmp_items = tmp_items.filter(func(i): return i != null)
	tmp_items.sort_custom(
		func(a, b):
			return a.category < b.category
	)
	Items = tmp_items
	Items.resize(MAX_SLOT_SIZE)
