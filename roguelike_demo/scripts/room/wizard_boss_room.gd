extends BaseRoom

@onready var stand_positions: Node2D = $StandPositions

var wizard_scene: PackedScene = preload("res://scenes/character/enemy/wizard_boss.tscn")

func _ready() -> void:
	enemy_num = 1

func spawn_wizard() -> void:
	var wizard = wizard_scene.instantiate() as WizardBoss
	wizard.tree_exited.connect(on_enemy_tree_exit)
	for child in stand_positions.get_children():
		wizard.set_stand_position(child.position)
	wizard.parent = self
	wizard.transfer_show()
	#add_child(wizard)
	call_deferred("add_child", wizard)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		if enemy_num > 0:
			spawn_wizard()
		else:
			open_doors()
		close_entrance()
	player_detector.queue_free()
