class_name ItemSlot
extends MarginContainer

@export var color_rect: ColorRect
@export var item_tile: ItemTile
var item: Item:
	set(value):
		item = value
		if item != null:
			item_tile.update_display(item)
			item_tile.show()
		else:
			item_tile.hide()

signal slot_pressed

func selected() -> void:
	color_rect.color = Color.WHITE

func deselected() -> void:
	color_rect.color = Color.BLACK

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			slot_pressed.emit()
