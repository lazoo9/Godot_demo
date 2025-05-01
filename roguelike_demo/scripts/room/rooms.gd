extends Node2D

@onready var player: Player = get_parent().get_node("Player")
@export var tile_size: int = 16
var spawn_rooms: Array[PackedScene] = [
	preload("res://scenes/rooms/spawn_room/spawn_room_1.tscn"),
	#preload("res://scenes/rooms/spawn_room/spawn_room_2.tscn")
]
var middle_simple_rooms: Array[PackedScene] = [
	#preload("res://scenes/rooms/boss_room/slime_boss_room.tscn")
	preload("res://scenes/rooms/simple_room/simple_room_1.tscn"),
	#preload("res://scenes/rooms/simple_room/simple_room_2.tscn"),
	#preload("res://scenes/rooms/simple_room/simple_room_3.tscn"),
	#preload("res://scenes/rooms/simple_room/simple_room_4.tscn")
]
var middle_hard_rooms: Array[PackedScene] = [
	preload("res://scenes/rooms/simple_room/simple_room_3.tscn"),
]
var special_rooms: Array[PackedScene] = [
	preload("res://scenes/rooms/special_room/special_room_1.tscn"),
]
var end_rooms: Array[PackedScene] = [
	preload("res://scenes/rooms/end_room/end_room_1.tscn"),
	preload("res://scenes/rooms/end_room/end_room_2.tscn"),
]
var slime_boss_room: PackedScene = preload("res://scenes/rooms/boss_room/slime_boss_room.tscn")
var wizard_boss_room: PackedScene = preload("res://scenes/rooms/boss_room/wizard_boss_room.tscn")

var room_num: int = 3
var pre_room: BaseRoom
var cur_room: BaseRoom

func _ready() -> void:
	generate_rooms()

func generate_rooms() -> void:
	if PlayerData.level <= 3:
		# simple
		for index in room_num:
			if index == 0:
				cur_room = spawn_rooms.pick_random().instantiate()
				pre_room = cur_room
				cur_room.global_position = global_position
				player.global_position = cur_room.get_node("PlayerSpawnPoint").global_position
				add_child(cur_room)
			else:
				if index == room_num - 1:
					cur_room = end_rooms.pick_random().instantiate()
				else:
					if PlayerData.level == 3 and index == room_num - 2:
						cur_room = slime_boss_room.instantiate()
					else:
						if PlayerData.level == 2 and index == room_num - 2:
							cur_room = special_rooms.pick_random().instantiate()
						else:
							cur_room = middle_simple_rooms.pick_random().instantiate()
				add_child(cur_room)
				link_rooms(pre_room, cur_room)
				pre_room = cur_room
	else:
		# hard
		for index in room_num:
			if index == 0:
				cur_room = spawn_rooms.pick_random().instantiate()
				pre_room = cur_room
				cur_room.global_position = global_position
				player.global_position = cur_room.get_node("PlayerSpawnPoint").global_position
				add_child(cur_room)
			else:
				if index == room_num-1:
					cur_room = end_rooms.pick_random().instantiate()
				else:
					if PlayerData.level == 5 and index == room_num - 2:
						cur_room = wizard_boss_room.instantiate()
					else:
						if PlayerData.level == 4 and index == room_num - 2:
							cur_room = special_rooms.pick_random().instantiate()
						else:
							cur_room = middle_simple_rooms.pick_random().instantiate()
				add_child(cur_room)
				link_rooms(pre_room, cur_room)
				pre_room = cur_room

func link_rooms(pre: BaseRoom, cur: BaseRoom) -> void:
	var pre_door_pos = pre.doors.get_node("Door").global_position
	var exit_tile_pos = pre.ground.local_to_map(pre.ground.to_local(pre_door_pos))
	# 走廊高度
	var height = randi_range(0, 4) + 2
	# 生成走廊
	#print(height)
	for y in height + 1:
		pre.ground.set_cell(exit_tile_pos + Vector2i(-1, -y), 0, Vector2i(3, 1))
		pre.ground.set_cell(exit_tile_pos + Vector2i(0, -y), 0, Vector2i(3, 1))
		if y != 0:
			pre.ground.set_cell(exit_tile_pos + Vector2i(-2, -y), 0, Vector2i(4, 5))
			pre.ground.set_cell(exit_tile_pos + Vector2i(1, -y), 0, Vector2i(3, 5))
	# 更新room位置，衔接room
	var spawn_pos = cur.entry_points.get_node("Marker2D2").global_position
	# 用spawn_pos的瓦片位置，不然使用spawn_pos的位置会导致衔接room会有偏移
	var spawn_tile_pos = cur.wall.local_to_map(cur.wall.to_local(spawn_pos))
	# 上一个room的door位置 + 走廊高度 + 当前room的高度 + 当前room Marker2D2的偏移量
	# 注意room的瓦片绘制,最上层需要与y=0对齐
	cur.global_position = pre_door_pos + tile_size * height * Vector2.UP + cur.wall.get_used_rect().size.y * tile_size * Vector2.UP + spawn_tile_pos.x * tile_size * Vector2.LEFT
