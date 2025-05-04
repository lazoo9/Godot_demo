extends StateMachine

func _init() -> void:
	add_state("idle")
	add_state("hide")
	add_state("show")
	add_state("hurt")
	add_state("death")
	add_state("spell")

func _ready() -> void:
	set_state(states.idle)

func _physics_process(delta: float) -> void:
	super(delta)

# 状态对应处理逻辑
func logic_state(_delta: float) -> void:
	pass

# 获取下个状态
func get_transition() -> int:
	match cur_state:
		states.hide:
			if not animation_player.is_playing():
				return states.show
		states.show:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
		states.spell:
			if not animation_player.is_playing():
				return states.idle
	return -1

# 进入状态
func enter_state(_pre_state: int, _cur_state: int) -> void:
	match _cur_state:
		states.idle:
			animation_player.play("idle")
		states.hide:
			animation_player.stop()
			animation_player.play("hide")
		states.show:
			animation_player.play("show")
		states.hurt:
			animation_player.play("hurt")
		states.spell:
			animation_player.stop()
			animation_player.play("spell")
		states.death:
			animation_player.play("death")
