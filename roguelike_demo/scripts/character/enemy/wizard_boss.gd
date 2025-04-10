extends Enemy
class_name WizardBoss

@onready var transfer_timer: Timer = $TransferTimer
@onready var spell_timer: Timer = $SpellTimer
@onready var ball_spawn_pos: Marker2D = $BallSpawnPos

var stand_positions: Array[Vector2] = []
var magic_ball_scene: PackedScene = preload("res://scenes/character/enemy/magic_ball.tscn")
var ice_piton_scene: PackedScene = preload("res://scenes/character/enemy/ice_piton.tscn")
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
	var ball = magic_ball_scene.instantiate() as Throwable
	ball.position = ball_spawn_pos.position
	#ball.set_dir(ball_spawn_pos.global_position.direction_to(player.global_position))
	ball.set_dir(Vector2.RIGHT)
	add_child(ball)

func spawn_ice_piton() -> void:
	for i in 12:
		var ice_piton = ice_piton_scene.instantiate() as Throwable
		var dir = Vector2.RIGHT.rotated(deg_to_rad(i * 30))
		add_child(ice_piton)
		ice_piton.global_position = dir * 12
		ice_piton.look_at(dir)
		ice_piton.set_dir(dir)
	pass

func spawn_climb() -> void:
	for i in 2:
		var climb = climb_scene.instantiate() as Climb
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		#climb.global_position = global_position
		parent.enemy_num += 1
		climb.death.connect(_on_climb_death)
		add_child(climb)
		climb.velocity += impulse_direction * 800

func _on_climb_death() -> void:
	parent.enemy_num -= 1

func _on_transfer_timer_timeout() -> void:
	print("hide")
	state_machine.set_state(state_machine.states.hide)

func _on_spell_timer_timeout() -> void:
	if state_machine.cur_state == state_machine.states.idle:
		#cast_spell()
		spawn_ice_piton()
