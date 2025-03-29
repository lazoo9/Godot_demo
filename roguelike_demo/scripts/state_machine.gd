extends Node
class_name StateMachine

@onready var parent: Character = get_parent()
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")

var states: Dictionary = {}
var pre_state: int = -1
var cur_state: int = -1:
	set(value):
		cur_state = value

# 处理逻辑
func _physics_process(_delta: float) -> void:
	if cur_state != -1:
		logic_state(_delta)
		var next_state = get_transition()
		if next_state != -1:
			set_state(next_state)

# 添加状态
func add_state(_state: String) -> void:
	states[_state] = states.size()

# 设置状态
func set_state(_state: int) -> void:
	exit_state(cur_state)
	pre_state = cur_state
	cur_state = _state
	enter_state(pre_state, cur_state)

# 状态对应处理逻辑
func logic_state(_delta: float) -> void:
	pass

# 获取下个状态
func get_transition() -> int:
	return -1

# 进入状态
func enter_state(_pre_state: int, _cur_state: int) -> void:
	pass

# 退出状态
func exit_state(_cur_state: int) -> void:
	pass
