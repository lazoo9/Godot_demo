extends Enemy
class_name WizardBoss

@onready var transfer_timer: Timer = $TransferTimer
@onready var spell_timer: Timer = $SpellTimer

var stand_positions: Array[Vector2] = []

func _ready() -> void:
	transfer_timer.timeout.connect(_on_transfer_timer_timeout)
	spell_timer.timeout.connect(_on_spell_timer_timeout)

func set_stand_position(pos: Vector2) -> void:
	stand_positions.append(pos)

func transfer_show() -> void:
	var pos = stand_positions.pick_random()
	global_position = pos

func cast_spell() -> void:
	pass

func _on_transfer_timer_timeout() -> void:
	state_machine.set_state(state_machine.states.hide)

func _on_spell_timer_timeout() -> void:
	if state_machine.cur_state == state_machine.states.idle:
		cast_spell()
