extends Control


func _on_start_button_pressed() -> void:
	SceneTransition.play_transition_for_main_ui()
	#get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")

func _on_continue_button_pressed() -> void:
	print("continue")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
