extends StateMachine

func _init() -> void:
	add_state("chase")
	add_state("hurt")
	add_state("death")

func _ready() -> void:
	set_state(states.chase)

# 状态对应处理逻辑
func logic_state(_delta: float) -> void:
	if cur_state == states.chase:
		parent.chase()
		parent.move(_delta)

# 获取下个状态
func get_transition() -> int:
	match cur_state:
		states.hurt:
			if not animation_player.is_playing():
				return states.chase
	return -1

# 进入状态
func enter_state(_pre_state: int, _cur_state: int) -> void:
	match _cur_state:
		states.chase:
			animation_player.play("fly")
		states.hurt:
			animation_player.play("hurt")
		states.death:
			animation_player.play("death")
