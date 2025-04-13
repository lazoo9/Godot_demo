extends BaseRoom

@onready var stand_positions: Node2D = $StandPositions

var wizard_scene: PackedScene = preload("res://scenes/character/enemy/wizard_boss.tscn")

func _ready() -> void:
	spawn_wizard()
	enemy_num = 1

func spawn_wizard() -> void:
	var wizard = wizard_scene.instantiate() as WizardBoss
	wizard.tree_exited.connect(on_enemy_tree_exit)
	for child in stand_positions.get_children():
		wizard.set_stand_position(child.position)
	wizard.parent = self
	wizard.transfer_show()
	add_child(wizard)
