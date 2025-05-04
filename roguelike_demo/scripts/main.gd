extends Node2D

@onready var player: Player = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var end_ui: MarginContainer = $UI/EndUI
@onready var skill_tree: Control = $UI/SkillTree
@onready var level_label: Label = $UI/LevelLabel

var skill_tree_open: bool = false
var end_ui_show: bool = false

func _ready() -> void:
	end_ui.hide()
	camera_2d.enabled = false
	level_label.text = "第 " + str(PlayerData.level) + " 层"
	player.death.connect(_on_player_death)
	PlayerData.level_changed.connect(_on_level_changed)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if end_ui_show:
			end_ui.hide()
			end_ui_show = false
		else:
			end_ui.show()
			end_ui_show = true
	if Input.is_action_just_pressed("open_skill_tree"):
		if skill_tree_open:
			skill_tree.hide()
			skill_tree_open = false
		else:
			skill_tree.show()
			skill_tree_open = true

func switch_camera() -> void:
	camera_2d.global_position = player.camera_2d.global_position
	camera_2d.enabled = true
	camera_2d.make_current()

func _on_player_death() -> void:
	switch_camera()
	end_ui.show()
	end_ui_show = true
	PlayerData.reset()
	PlayerData.save_to_file()
	Game.reload_weapon()

func _on_level_changed(level: int) -> void:
	level_label.text = "第 " + str(level) + " 层"

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_return_main_ui_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_ui.tscn")

func _on_restart_game_pressed() -> void:
	PlayerData.reset()
	SceneTransition.play_transition_for_main_ui()
	Game.reload_weapon()
