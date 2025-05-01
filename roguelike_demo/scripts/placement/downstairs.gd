extends Area2D
class_name Downstairs

func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(body) and body is Player:
		if PlayerData.level == 5:
			SceneTransition.play_transition_for_final_ui()
		else:
			PlayerData.level += 1
			SceneTransition.play_transition()
