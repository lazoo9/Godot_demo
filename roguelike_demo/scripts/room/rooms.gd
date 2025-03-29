extends Node2D

@onready var player: Player = get_parent().get_node("Player")
@export var tile_size: int = 16
var spawn_rooms: Array[PackedScene] = [preload("res://scenes/rooms/spawn_room_1.tscn")]
var middle_rooms: Array[PackedScene] = [preload("res://scenes/rooms/room_1.tscn")]
var end_rooms: Array[PackedScene] = [preload("res://scenes/rooms/room_1.tscn")]

var room_num: int = 3
var pre_room: BaseRoom
var cur_room: BaseRoom

func _ready() -> void:
	generate_rooms()

func generate_rooms() -> void:
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
				cur_room = middle_rooms.pick_random().instantiate()
			add_child(cur_room)
			link_rooms(pre_room, cur_room)
			pre_room = cur_room

func link_rooms(pre: BaseRoom, cur: BaseRoom) -> void:
	var pre_door_pos = pre.doors.get_node("Door").global_position
	var exit_tile_pos = pre.ground.local_to_map(pre.ground.to_local(pre_door_pos))
	# 走廊高度
	var height = randi_range(0, 4) + 2
	# 生成走廊
	for y in height:
		pre.ground.set_cell(exit_tile_pos + Vector2i(-2, -y), 0, Vector2i(4, 5))
		pre.ground.set_cell(exit_tile_pos + Vector2i(-1, -y), 0, Vector2i(3, 1))
		pre.ground.set_cell(exit_tile_pos + Vector2i(0, -y), 0, Vector2i(3, 1))
		pre.ground.set_cell(exit_tile_pos + Vector2i(1, -y), 0, Vector2i(3, 5))
	# 更新room位置，衔接room
	var spawn_pos = cur.entry_points.get_node("Marker2D2").global_position
	# 用spawn_pos的瓦片位置，不然使用spawn_pos的位置会导致衔接room会有偏移
	var spawn_tile_pos = cur.wall.local_to_map(spawn_pos)
	# 上一个room的door位置 + 走廊高度 + 当前room的高度 + 当前room Marker2D2的偏移量
	cur.global_position = pre_door_pos + tile_size * height * Vector2.UP + cur.wall.get_used_rect().size.y * tile_size * Vector2.UP + spawn_tile_pos.x * tile_size * Vector2.LEFT
