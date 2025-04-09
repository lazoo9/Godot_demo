extends Enemy
class_name WizardBoss

@onready var transfer_timer: Timer = $TransferTimer
@onready var spell_timer: Timer = $SpellTimer

var stand_positions: Array[Vector2] = []
var magic_ball_scene: PackedScene = preload("res://scenes/character/enemy/magic_ball.tscn")
var climb_scene: PackedScene = preload("res://scenes/character/enemy/climb.tscn")
var parent

func _ready() -> void:
	transfer_timer.timeout.connect(_on_transfer_timer_timeout)
	spell_timer.timeout.connect(_on_spell_timer_timeout)

func set_stand_position(pos: Vector2) -> void:
	stand_positions.append(pos)

func transfer_show() -> void:
	var pos = stand_positions.pick_random()
	global_position = pos
	show()

func cast_spell() -> void:
	pass

func spawn_climb() -> void:
	for i in 2:
		var climb = climb_scene.instantiate() as Climb
		climb.global_position = global_position
		parent.enemy_num += 1
		climb.death.connect(_on_climb_death)
		add_child(climb)

func _on_climb_death() -> void:
	parent.enemy_num -= 1

func _on_transfer_timer_timeout() -> void:
	print("hide")
	state_machine.set_state(state_machine.states.hide)

func _on_spell_timer_timeout() -> void:
	if state_machine.cur_state == state_machine.states.idle:
		cast_spell()
