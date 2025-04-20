extends Control

@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton

func _ready() -> void:
	if not FileAccess.file_exists(PlayerData.file_path):
		continue_button.disabled = true

func _on_start_button_pressed() -> void:
	PlayerData.reset()
	SceneTransition.play_transition_for_main_ui()

func _on_continue_button_pressed() -> void:
	PlayerData.load_from_file()
	SceneTransition.play_transition_for_main_ui()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
