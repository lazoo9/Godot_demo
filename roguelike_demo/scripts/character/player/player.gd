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
signal weapon_pick_up(weapon_index: int)         
signal weapon_drop(weapon_index: int)
signal weapon_switch(pre_weapon_index: int, next_weapon_index: int)                                                                                                                                                                                           

func _ready() -> void:
	Game.player = self
	load_data()
	#cur_hp = PlayerData.max_hp
	#for w in PlayerData.weapons:
		#var weapon = w.duplicate()
		#weapon.hide()
		#weapons.add_child(weapon)
	#current_weapon = weapons.get_child(PlayerData.cur_weapon_index)
	#current_weapon.show()
	#cur_hp = PlayerData.max_hp
	#for w in weapons.get_children():
		#PlayerData.weapons.append(w.duplicate())
		#w.hide()
	#current_weapon = weapons.get_child(0)
	#current_weapon.show()
	#PlayerData.cur_weapon = 0

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
	var pre_index = index
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
	weapon_switch.emit(pre_index, index)

# 拾取武器
func pick_up_weapon(weapon: Weapon) -> void:
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", self)
	call_deferred("_pick_up_weapon", weapon)

func _pick_up_weapon(weapon: Weapon) -> void:
	current_weapon.hide()
	current_weapon.cancel_attack()
	var pre_index: int = current_weapon.get_index()
	current_weapon = weapon
	var index: int = current_weapon.get_index()
	weapon_pick_up.emit(index)
	weapon_switch.emit(pre_index, index)

# 丢弃武器
func drop_weapon() -> void:
	if weapons.get_child_count() == 1:
		return
	var weapon = current_weapon
	var pre_index = current_weapon.get_index()
	switch_weapon(SWITCH_DIR.DOWN)
	weapon.show()
	#weapons.remove_child(weapon)
	weapons.call_deferred("remove_child", weapon)
	#get_parent().add_child(weapon)
	get_parent().call_deferred("add_child", weapon)
	#weapon.owner = get_parent()
	weapon.set_deferred("owner", get_parent())
	call_deferred("_drop_weapon", weapon, pre_index)
	#var drop_dir = global_position.direction_to(get_global_mouse_position())
	#weapon.global_position = global_position
	#weapon.drop(global_position + drop_dir * 50)
	#weapon_drop.emit(pre_index)
	#weapon_switch.emit(pre_index, pre_index - 1)

func _drop_weapon(weapon: Weapon, pre_index: int) -> void:
	var drop_dir = global_position.direction_to(get_global_mouse_position())
	weapon.global_position = global_position
	weapon.drop(global_position + drop_dir * 50)
	weapon_drop.emit(pre_index)
	weapon_switch.emit(pre_index, pre_index - 1)

func take_damage(damage: int, knock_dirention: Vector2, knock_force: int) -> void:
	velocity = Vector2.ZERO
	cur_hp -= damage
	if cur_hp > 0:
		cancel_attack()
		state_machine.set_state(state_machine.states.hurt)
		velocity = knock_dirention * knock_force * 2
	else:
		cancel_attack()
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

func save_data() -> void:
	PlayerData.cur_hp = cur_hp
	PlayerData.weapons.clear()
	PlayerData.weapons.resize(weapons.get_child_count())
	for i in weapons.get_child_count():
		PlayerData.weapons[i] = weapons.get_child(i).duplicate()
	PlayerData.cur_weapon_index = current_weapon.get_index()

func load_data() -> void:
	cur_hp = PlayerData.cur_hp
	for w in weapons.get_children():
		weapons.remove_child(w)
		w.queue_free()
	var index: int = 0
	for w in PlayerData.weapons:
		var weapon = w.duplicate()
		weapon.hide()
		weapons.add_child(weapon)
		weapon_pick_up.emit(index)
		index += 1
	current_weapon = weapons.get_child(PlayerData.cur_weapon_index)
	current_weapon.show()
	weapon_switch.emit(PlayerData.cur_weapon_index, PlayerData.cur_weapon_index)

func _on_dust_timer_timeout() -> void:
	spawn_dust()
