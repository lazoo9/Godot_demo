extends Area2D
class_name HealthPotion

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("spawn")

func _on_body_entered(body: Node2D) -> void:
	if body is Player and is_instance_valid(body):
		body.cur_hp += 1
		animation_player.play("pick_up")
