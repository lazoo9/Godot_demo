extends Area2D
class_name Downstairs

func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(body) and body is Player:
		Game.change_scene()
