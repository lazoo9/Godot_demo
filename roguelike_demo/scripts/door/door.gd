extends StaticBody2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("close")

func open() -> void:
	animation_player.call_deferred("play", "open")
