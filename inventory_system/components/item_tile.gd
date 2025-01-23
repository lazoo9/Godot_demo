class_name ItemTile
extends MarginContainer

@export var item_store: Item:
	set(value):
		if item_store != null:
			item_store.quantity_change.disconnect(on_quantity_change)
		item_store = value
		if item_store != null:
			item_store.quantity_change.connect(on_quantity_change)
@export var texture_rect: TextureRect
@export var quantity_label: Label

func update_display(item: Item) -> void:
	item_store = item
	texture_rect.texture = item_store.icon
	if item_store.max_quantity <= 1:
		quantity_label.hide()
	else:
		quantity_label.show()
		quantity_label.text = str(item_store.quantity)

func on_quantity_change(value: int) -> void:
	#if item_store.quantity <= 0:
		#item_store = null
		#return
	if item_store.max_quantity > 1:
		quantity_label.text = str(value)
