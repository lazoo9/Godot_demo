extends StateMachine

func _init() -> void:
	add_state("idle")
	add_state("jump")
	add_state("hurt")
	add_state("death")

func _ready() -> void:
	set_state(states.idle)

# 状态对应处理逻辑
func logic_state(_delta: float) -> void:
	if cur_state == states.jump:
		parent.chase()
		parent.move(_delta)
	elif cur_state == states.idle:
		parent.velocity = Vector2.ZERO

# 获取下个状态
func get_transition() -> int:
	match cur_state:
		states.jump:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1

# 进入状态
func enter_state(_pre_state: int, _cur_state: int) -> void:
	match _cur_state:
		states.idle:
			animation_player.play("idle")
		states.jump:
			animation_player.play("jump")
		states.hurt:
			animation_player.play("hurt")
		states.death:
			if animation_player.current_animation == "death":
				return
			else:
				animation_player.play("death")
