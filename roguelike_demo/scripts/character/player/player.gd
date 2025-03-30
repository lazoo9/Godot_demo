extends Character
class_name Player

enum SWITCH_DIR {
	UP,
	DOWN
}

@onready var sprite_2d: Sprite2D = $Body/Sprite2D
@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapons: Node2D = $Body/Weapons
@onready var dust_timer: Timer = $DustTimer

@export var max_hp: int = 4
var cur_hp: int = 0:
	set(value):
		cur_hp = value
		hp_change.emit(cur_hp, max_hp)
var current_weapon: Weapon
var dust_scene: PackedScene = preload("res://scenes/effect/dust.tscn")

signal hp_change(cur_hp: int, max_hp: int)                                                                                                                                                                                                             

func _ready() -> void:
	cur_hp = max_hp
	for w in weapons.get_children():
		w.hide()
	current_weapon = weapons.get_child(0)
	current_weapon.show()

func _physics_process(_delta: float) -> void:
	super(_delta)
	move_direction = (get_global_mouse_position() - global_position).normalized()
	if move_direction.x > 0 and sprite_2d.flip_h:
		sprite_2d.flip_h = false
	elif move_direction.x < 0 and not sprite_2d.flip_h:
		sprite_2d.flip_h = true
		
	#if dir.x > 0 and sprite_2d.flip_h:
		#sprite_2d.flip_h = false
	#elif dir.x < 0 and not sprite_2d.flip_h:
		#sprite_2d.flip_h = true
	current_weapon.move(move_direction)
	current_weapon.get_input()

func cancel_attack() -> void:
	current_weapon.animation_player.play("cancel_attack")

func get_input() -> void:
	move_direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	
	if not current_weapon.is_busy():
		if Input.is_action_just_released("switch_up"):
			switch_weapon(SWITCH_DIR.UP)
		if Input.is_action_just_released("switch_down"):
			switch_weapon(SWITCH_DIR.DOWN)
	
	if Input.is_action_just_released("drop"):
		drop_weapon()

# 切换武器
func switch_weapon(dir: SWITCH_DIR) -> void:
	var index = current_weapon.get_index()
	if dir == SWITCH_DIR.UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()

# 拾取武器
func pick_up_weapon(weapon: Weapon) -> void:
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", self)
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon

# 丢弃武器
func drop_weapon() -> void:
	if weapons.get_child_count() == 1:
		return
	var weapon = current_weapon
	switch_weapon(SWITCH_DIR.DOWN)
	weapon.show()
	weapons.remove_child(weapon)
	get_parent().add_child(weapon)
	weapon.owner = get_parent()
	var drop_dir = global_position.direction_to(get_global_mouse_position())
	weapon.global_position = global_position
	weapon.drop(global_position + drop_dir * 50)

func take_damage(damage: int, knock_dirention: Vector2, knock_force: int) -> void:
	velocity = Vector2.ZERO
	cur_hp -= damage
	if cur_hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity = knock_dirention * knock_force * 2
	else:
		state_machine.set_state(state_machine.states.death)
		velocity = knock_dirention * knock_force * 2

func is_hurting() -> bool:
	if animation_player.is_playing() and animation_player.current_animation == "hurt":
		return true
	return false

func is_dead() -> bool:
	if cur_hp > 0:
		return false
	return true

func spawn_dust() -> void:
	var dust = dust_scene.instantiate() as Dust
	dust.global_position = global_position + Vector2.DOWN * 4
	dust.flip_h = sprite_2d.flip_h
	get_tree().current_scene.add_child(dust)

func _on_dust_timer_timeout() -> void:
	spawn_dust()
