extends Character
class_name Enemy

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Body/Sprite2D
@onready var state_machine: Node = $StateMachine
var player: Character = null

@export var max_hp: int = 4
var cur_hp: int = 0:
	set(value):
		cur_hp = value

func _ready() -> void:
	cur_hp = max_hp
	call_deferred("actor_set")

func _physics_process(delta: float) -> void:
	super(delta)
	if player:
		# 设置导航最终位置
		navigation_agent_2d.target_position = player.global_position
		# 修改朝向
		var dir = global_position.direction_to(player.global_position)
		if dir.x > 0 and sprite_2d.flip_h:
			sprite_2d.flip_h = false
		elif dir.x < 0 and not sprite_2d.flip_h:
			sprite_2d.flip_h = true

func actor_set() -> void:
	await get_tree().physics_frame
	var player_node = get_tree().current_scene.get_node("Player")
	navigation_agent_2d.target_position = player_node.global_position
	navigation_agent_2d.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	player = player_node

func chase() -> void:
	var next_position = navigation_agent_2d.get_next_path_position()
	move_direction = global_position.direction_to(next_position)

func take_damage(damage: int, knock_dirention: Vector2, knock_force: int) -> void:
	cur_hp -= damage
	if cur_hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity = knock_dirention * knock_force
	else:
		state_machine.set_state(state_machine.states.death)
		velocity = knock_dirention * knock_force * 2
