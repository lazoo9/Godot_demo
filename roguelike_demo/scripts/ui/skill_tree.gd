extends Control

@onready var panel: Panel = $Panel
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

var skill_node_dict = {}

func _ready() -> void:
	panel.show_behind_parent = true
	store_dict()
	load_data()

func _process(_delta: float) -> void:
	queue_redraw()

func store_dict() -> void:
	for v in h_box_container.get_children():
		for node in v.get_children():
			skill_node_dict[node.skill_resource.id] = node

func load_data() -> void:
	for id in PlayerData.activated_skills:
		var skill_node = skill_node_dict[int(id)]
		skill_node.skill_resource.active = true
		skill_node.activated()

func _draw() -> void:
	for id in skill_node_dict:
		var skill_node = skill_node_dict[id]
		for reqired in skill_node.skill_resource.required_skill:
			var required_node = skill_node_dict[reqired.id]
			var start_pos: Vector2 = skill_node.global_position + skill_node.size / 2
			var end_pos: Vector2 = required_node.global_position + required_node.size / 2
			var color: Color = Color.GRAY if required_node.skill_resource.active else Color.BLACK
			draw_line(start_pos, end_pos, color, 3.0)
