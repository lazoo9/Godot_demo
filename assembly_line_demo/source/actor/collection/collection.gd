class_name Collection
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health: int = 3
@export var drop_item_scene: PackedScene

func _ready() -> void:
	animation_player.play("spawn")
	await animation_player.animation_finished

func hit(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	animation_player.play("die")
	await animation_player.animation_finished
	var item: DropItem = drop_item_scene.instantiate() as DropItem
	item.position = global_position
	get_parent().add_child(item)
	get_parent().remove_child(self)
	queue_free()
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			hit(1)
