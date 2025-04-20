extends Enemy
class_name WizardBoss

@onready var transfer_timer: Timer = $TransferTimer
@onready var spell_timer: Timer = $SpellTimer
@onready var ball_spawn_pos: Marker2D = $BallSpawnPos

@export var min_distance: float = 40.0
@export var max_distance: float = 130.0

var spell_count: int = 0
var stand_positions: Array[Vector2] = []
var magic_ball_scene: PackedScene = preload("res://scenes/character/enemy/magic_ball.tscn")
var ice_piton_scene: PackedScene = preload("res://scenes/character/enemy/ice_piton.tscn")
var climb_scene: PackedScene = preload("res://scenes/character/enemy/climb.tscn")
var parent

func _ready() -> void:
	super()
	transfer_timer.timeout.connect(_on_transfer_timer_timeout)
	spell_timer.timeout.connect(_on_spell_timer_timeout)

func set_stand_position(pos: Vector2) -> void:
	stand_positions.append(pos)

func transfer_show() -> void:
	var pos = stand_positions.pick_random()
	position = pos
	show()

func cast_magic_ball() -> void:
	var ball = magic_ball_scene.instantiate() as Throwable
	ball.position = ball_spawn_pos.position
	if player:
		ball.set_dir(ball_spawn_pos.global_position.direction_to(player.global_position))
	else:
		ball.set_dir(Vector2.RIGHT)
	add_child(ball)

func spawn_ice_piton() -> void:
	for i in 12:
		var ice_piton = ice_piton_scene.instantiate() as Throwable
		var dir = Vector2.RIGHT.rotated(deg_to_rad(i * 30))
		add_child(ice_piton)
		ice_piton.position = dir * 12
		ice_piton.rotation_degrees = i * 30
		ice_piton.set_dir(dir)

func spawn_climb() -> void:
	var room_node = find_parent("WizardBossRoom")
	for i in 2:
		var climb = climb_scene.instantiate() as Climb
		climb.tree_exited.connect(parent.on_enemy_tree_exit)
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		climb.position = position
		parent.enemy_num += 1
		climb.death.connect(_on_climb_death)
		room_node.add_child(climb)
		climb.velocity += impulse_direction * 800

func cast_spell() -> void:
	if spell_count != 3:
		cast_magic_ball()
		spell_count += 1
	else:
		if is_instance_valid(player):
			var distance = global_position.distance_to(player.global_position)
			if distance > min_distance and distance < max_distance:
				spawn_ice_piton()
			else:
				spawn_climb()
			spell_count = 0

func dead() -> void:
	transfer_timer.timeout.disconnect(_on_transfer_timer_timeout)
	spell_timer.timeout.disconnect(_on_spell_timer_timeout)
	queue_free()

func _on_climb_death() -> void:
	parent.enemy_num -= 1

func _on_transfer_timer_timeout() -> void:
	if cur_hp > 0:
		state_machine.set_state(state_machine.states.hide)

func _on_spell_timer_timeout() -> void:
	if state_machine.cur_state == state_machine.states.idle:
		state_machine.set_state(state_machine.states.spell)
