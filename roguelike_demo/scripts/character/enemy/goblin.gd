extends Enemy
class_name Goblin

@onready var retrate_timer: Timer = $RetrateTimer
@onready var shoot_timer: Timer = $ShootTimer

@export var min_distance: float = 25.0
@export var max_distance: float = 90.0

var distance: float = 0.0
var projectile_scene: PackedScene = preload("res://scenes/character/enemy/throwable_knife.tscn")

func _physics_process(delta: float) -> void:
	super(delta)
	if player:
		# 修改朝向
		var dir = global_position.direction_to(player.global_position)
		if dir.x > 0 and sprite_2d.flip_h:
			sprite_2d.flip_h = false
		elif dir.x < 0 and not sprite_2d.flip_h:
			sprite_2d.flip_h = true
		distance = global_position.distance_to(player.global_position)

func chase() -> void:
	if distance > max_distance and retrate_timer.is_stopped():
		shoot_timer.stop()
		if is_instance_valid(player):
			navigation_agent_2d.set_navigation_layer_value(1, true)
			# 设置导航最终位置
			navigation_agent_2d.target_position = player.global_position
			var next_position = navigation_agent_2d.get_next_path_position()
			move_direction = global_position.direction_to(next_position)
	elif distance < min_distance or not retrate_timer.is_stopped():
		shoot_timer.stop()
		if is_instance_valid(player):
			navigation_agent_2d.set_navigation_layer_value(1, true)
			var dir = player.global_position.direction_to(global_position)
			navigation_agent_2d.target_position = global_position + dir * 100
			var next_position = navigation_agent_2d.get_next_path_position()
			move_direction = global_position.direction_to(next_position)
			if retrate_timer.is_stopped():
				retrate_timer.start(0.6)
	else:
		navigation_agent_2d.set_navigation_layer_value(1, false)
		move_direction = Vector2.ZERO
		if shoot_timer.is_stopped():
			shoot_timer.start()

func throw_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	get_tree().current_scene.add_child(projectile)

func _on_shoot_timer_timeout() -> void:
	throw_projectile()
