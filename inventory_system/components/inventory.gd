class_name Inventory
extends MarginContainer

@export var close_btn: Button
@export var switch_tab_bar: TabBar
@export var grid_container: GridContainer
@export var drop_btn: Button
@export var packet_btn: Button
var c_inventory: C_Inventory:
	set(value):
		if c_inventory != null:
			c_inventory.item_change.disconnect(on_item_change)
			var index = 0
			for slot in grid_container.get_children():
				slot.slot_pressed.disconnect(on_pressed.bind(index))
				++index
		c_inventory = value
		if c_inventory != null:
			c_inventory.item_change.connect(on_item_change)
			var index = 0
			for slot in grid_container.get_children():
				slot.slot_pressed.connect(on_pressed.bind(index))
				slot.item = c_inventory.Items[index]
				index += 1

# 背包栏索引
var select_index: int = 0:
	set(value):
		var slot = get_slot(select_index)
		slot.deselected()
		select_index = value
		slot = get_slot(select_index)
		slot.selected()
# 物品种类索引
var current_category: int = 0

# 打开背包
func open() -> void:
	select_index = 0
	switch_tab_bar.current_tab = 0
	show()

# 切换物品种类
func switch_tab(tab: int) -> void:
	select_index = 0
	current_category = tab
	update_display()

# 更新物品展示
func update_display() -> void:
	var items = c_inventory.get_similar_category_items(current_category)
	for i in items.size():
		var slot = get_slot(i)
		if slot != null: 
			slot.item = items[i]

func get_slot(index: int) -> ItemSlot:
	return grid_container.get_child(index) as ItemSlot

func on_item_change() -> void:
	update_display()

func on_pressed(index: int) -> void:
	select_index = index

func _on_close_button_pressed() -> void:
	hide()

func _on_drop_button_pressed() -> void:
	c_inventory.delete_item(select_index)

func _on_packet_button_pressed() -> void:
	c_inventory.packet_items()

func _on_switch_tab_bar_tab_changed(tab: int) -> void:
	switch_tab(tab)
