extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_transition() -> void:
	animation_player.play("transition")

func change() -> void:
	Game._change_scene()
