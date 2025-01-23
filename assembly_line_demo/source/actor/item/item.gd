class_name Item
extends Resource

@export var name: String = "名称"
@export var icon: Texture2D = null
@export var max_quantity: int = 0
@export var quantity: int = 0

func can_merge(other_item: Item) -> bool:
	return name == other_item.name
