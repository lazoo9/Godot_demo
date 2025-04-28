extends MarginContainer
class_name SkillNode

@onready var panel: Panel = $Panel
@onready var description: Label = $VBoxContainer/Description
@onready var texture_button: TextureButton = $VBoxContainer/TextureButton
@onready var cost_label: Label = $VBoxContainer/HBoxContainer/CostLabel

@export var skill_resource: SkillResource

func _ready() -> void:
	description.text = skill_resource.description
	texture_button.texture_normal = skill_resource.icon
	cost_label.text = "消耗*" + str(skill_resource.cost)

func _on_texture_button_pressed() -> void:
	if PlayerData.skill_point_num < skill_resource.cost:
		return
	for required in skill_resource.required_skill:
		if not required.active:
			return
	SkillManager.activate_skill(skill_resource)
	activated()

func activated() -> void:
	panel.show_behind_parent = true
