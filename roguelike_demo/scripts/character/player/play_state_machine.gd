extends StateMachine

func _init() -> void:
	add_state("idle")
	add_state("run")
	add_state("hurt")
	add_state("death")

func _ready() -> void:
	set_state(states.idle)

# 状态对应处理逻辑
func logic_state(_delta: float) -> void:
	if cur_state == states.idle or cur_state == states.run:
		parent.get_input()
		parent.move(_delta)

# 获取下个状态
func get_transition() -> int:
	match cur_state:
		states.idle:
			if parent.velocity.length() > 1:
				return states.run
		states.run:
			if parent.velocity.length() < 1:
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
		states.run:
			animation_player.play("run")
		states.hurt:
			animation_player.play("hurt")
			parent.cancel_attack()
		states.death:
			animation_player.play("death")
			parent.cancel_attack()
