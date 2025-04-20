extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_transition() -> void:
	animation_player.play("transition")

func play_transition_for_main_ui() -> void:
	animation_player.play("transition_for_main_ui")
	
func play_transition_for_final_ui() -> void:
	animation_player.play("transition_for_final_ui")

func change() -> void:
	Game.save_data()
	PlayerData.save_to_file()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
	Game.load_data()

func change_for_main_ui() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")

func change_for_final_ui() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/final_ui.tscn")
