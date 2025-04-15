extends PanelContainer
class_name WeaponInventory

@onready var h_box_container: HBoxContainer = $HBoxContainer

@export var player: Player

var weapon_slot_scene: PackedScene = preload("res://scenes/ui/weapon_slot.tscn")


func _ready() -> void:
	player.weapon_pick_up.connect(_on_player_weapon_pick_up)
	player.weapon_drop.connect(_on_player_weapon_drop)
	player.weapon_switch.connect(_on_player_weapon_switch)

func _on_player_weapon_pick_up(weapon_index: int) -> void:
	var weapon_slot = weapon_slot_scene.instantiate() as WeaponSlot
	h_box_container.add_child(weapon_slot)
	weapon_slot.initialize(player.weapons.get_child(weapon_index).sprite_2d.texture)

func _on_player_weapon_drop(weapon_index: int) -> void:
	h_box_container.get_child(weapon_index).queue_free()

func _on_player_weapon_switch(pre_weapon_index: int, next_weapon_index: int) -> void:
	h_box_container.get_child(pre_weapon_index).deselect()
	h_box_container.get_child(next_weapon_index).select()
