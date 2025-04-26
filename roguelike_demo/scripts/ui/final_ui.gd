extends Control

@onready var player_animation_player: AnimationPlayer = $PlayerAnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var doro_animation_player: AnimationPlayer = $DoroAnimationPlayer
@onready var doro: TextureRect = $Doro

func _ready() -> void:
	doro.pivot_offset = doro.size / 2
	player_animation_player.play("run")
	animation_player.play("run_over_there")
	doro_animation_player.play("scanle_change")

func _on_return_main_ui_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_ui.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
