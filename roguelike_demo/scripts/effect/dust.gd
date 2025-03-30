extends Sprite2D
class_name Dust

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("spawn")
