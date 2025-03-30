extends Enemy
class_name SlimeBoss

@onready var jump_timer: Timer = $JumpTimer
@onready var hit_box: HitBox = $Body/Sprite2D/HitBox

var slime_scene: PackedScene = preload("res://scenes/character/enemy/slime_boss.tscn")

func _physics_process(delta: float) -> void:
	super(delta)
	if player:
		hit_box.knock_direction = global_position.direction_to(player.global_position)
		if global_position.y + 8.0 < player.global_position.y:
			player.z_index = 1
		else:
			player.z_index = 0

func chase() -> void:
	var next_position = navigation_agent_2d.get_final_position()
	move_direction = global_position.direction_to(next_position)

# 死亡后分裂史莱姆
func split_smile() -> void:
	if scale > Vector2(1, 1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		spawn_slime(impulse_direction)
		spawn_slime(impulse_direction * -1)

# 生成史莱姆
func spawn_slime(direction: Vector2) -> void:
	var slime = slime_scene.instantiate() as SlimeBoss
	slime.global_position = global_position
	slime.scale = scale / 2
	get_parent().add_child(slime)
	slime.jump_timer.wait_time = jump_timer.wait_time - 0.5
	slime.velocity += direction * 1500

func _on_jump_timer_timeout() -> void:
	state_machine.set_state(state_machine.states.jump)
