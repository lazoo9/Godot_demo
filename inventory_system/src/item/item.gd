class_name Item
extends Resource

# item种类
enum ITEM_TYPE {
	NONE,
	EQUPIMENT,
	MATERIAL,
	FOOD,
}

@export var name: String = "物品名称"
@export var icon: Texture = null
@export var description: String = "物品描述"
@export var category: ITEM_TYPE = ITEM_TYPE.NONE
@export var max_quantity: int = 0 # 所携带的最大数量
@export var quantity: int: # 当前携带数量
	set(value):
		quantity = clamp(value, 0, max_quantity)
		quantity_change.emit(value)
@export var weight: int = 0 # 装备重量
@export var attribute: Dictionary = {} # 属性

signal quantity_change

func is_max_quantity() -> bool:
	return self.quantity >= self.max_quantity

func can_item_merge(other_item: Item) -> bool:
	return self.item == other_item.name

func merge_quantity(other_item: Item) -> void:
	var sum_quantity = self.quantity + other_item.quantity
	self.quantity = mini(sum_quantity, max_quantity)
	other_item.quantity = maxi(0, sum_quantity-max_quantity)
