extends Control


func _on_start_button_pressed() -> void:
	PlayerData.level = 1
	SceneTransition.play_transition_for_main_ui()

func _on_continue_button_pressed() -> void:
	print("continue")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
