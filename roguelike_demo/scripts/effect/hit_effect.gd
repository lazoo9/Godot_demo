extends Sprite2D
class_name HitEffect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("spawn")
