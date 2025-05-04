extends BaseRoom

@onready var stand_positions: Node2D = $StandPositions

var wizard_scene: PackedScene = preload("res://scenes/character/enemy/wizard_boss.tscn")
var is_wizard_dead: bool = false

func _ready() -> void:
	# 单独逻辑
	pass

func spawn_wizard() -> void:
	var wizard = wizard_scene.instantiate() as WizardBoss
	wizard.wizard_dead.connect(_on_wizard_dead)
	for child in stand_positions.get_children():
		wizard.set_stand_position(child.position)
	wizard.parent = self
	wizard.transfer_show()
	call_deferred("add_child", wizard)

func _on_wizard_dead() -> void:
	is_wizard_dead = true
	if enemy_num <= 0:
		spawn_chests()
		open_doors()

func on_enemy_tree_exit() -> void:
	enemy_num -= 1
	if enemy_num <= 0 and is_wizard_dead:
		spawn_chests()
		open_doors()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		spawn_wizard()
		close_entrance()
	player_detector.queue_free()
