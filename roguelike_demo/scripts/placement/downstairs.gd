extends Area2D
class_name Downstairs

func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(body) and body is Player:
		if PlayerData.level == 5:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/final_ui.tscn")
		else:
			PlayerData.level += 1
			SceneTransition.play_transition()
