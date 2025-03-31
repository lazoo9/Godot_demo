extends Node

func change_scene() -> void:
	SceneTransition.play_transition()

func _change_scene() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
