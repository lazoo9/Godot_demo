extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_transition() -> void:
	animation_player.play("transition")

func change() -> void:
	Game.save_data()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
	Game.load_data()
