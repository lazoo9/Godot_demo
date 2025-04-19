extends Node2D

@onready var player: Player = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var end_ui: MarginContainer = $UI/EndUI

func _ready() -> void:
	end_ui.hide()
	camera_2d.enabled = false
	player.death.connect(_on_player_death)

func switch_camera() -> void:
	camera_2d.global_position = player.camera_2d.global_position
	camera_2d.enabled = true
	camera_2d.make_current()

func _on_player_death() -> void:
	switch_camera()
	end_ui.show()

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_return_main_ui_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_ui.tscn")

func _on_restart_game_pressed() -> void:
	PlayerData.clear_weapons()
	PlayerData.reset()
	SceneTransition.play_transition_for_main_ui()
