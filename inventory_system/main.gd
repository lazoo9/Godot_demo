extends Node2D

@export var player: Node2D
@export var texture_btn: TextureButton
@export var inventory: Inventory
@export var line_edit: LineEdit
@export var submit_btn: Button

func _ready() -> void:
	inventory.hide()
	inventory.c_inventory = player.get_node("C_Inventory")

func exec_command(command: String) -> void:
	var parts = command.split(" ")
	if parts.size() == 0:
		return
	var cmd = parts[0]
	var args = parts.slice(1, parts.size())
	if has_method(cmd):
		self.callv(cmd, args)
	else:
		push_warning("未找到指令: ", cmd)

func add_item(item_name: String, item_quantity: String) -> void:
	var quantity: int = int(item_quantity)
	var item = create_item(item_name, quantity)
	if item == null: return
	var c_inventory = player.get_node("C_Inventory") as C_Inventory
	c_inventory.add_item(item)
	#inventory.c_inventory.add_item(item)
	print_debug("add_item: ", item_name, ",quantity: ", item_quantity)

func delete_item(index: int) -> void:
	inventory.c_inventory.delete_item(index)

func create_item(item_name: String, item_quantity: int) -> Item:
	var path = "res://src/item/" + item_name +".tres"
	if not ResourceLoader.exists(path): return null
	var item: Item = load(path).duplicate() as Item
	item.quantity = item_quantity
	return item

func _on_texture_button_pressed() -> void:
	inventory.open()

func _on_line_edit_text_submitted(new_text: String) -> void:
	exec_command(new_text)

func _on_submit_button_pressed() -> void:
	exec_command(line_edit.text)
