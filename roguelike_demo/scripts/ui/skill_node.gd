extends MarginContainer
class_name SkillNode

@onready var panel: Panel = $Panel
@onready var description: Label = $VBoxContainer/Description

@export var skill_resource: SkillResource

func _ready() -> void:
	description.text = skill_resource.description

func _on_texture_button_pressed() -> void:
	for required in skill_resource.required_skill:
		if not required.active:
			return
	SkillManager.activate_skill(skill_resource)
	activated()

func activated() -> void:
	panel.show_behind_parent = true
