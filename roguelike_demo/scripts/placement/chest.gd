extends Area2D
class_name Chest

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var drop_items: Array[PackedScene] = [
	preload("res://scenes/placement/bomb.tscn"),
	preload("res://scenes/placement/health_potion.tscn"),
	preload("res://scenes/placement/skill_point.tscn")
]

func _ready() -> void:
	animation_player.play("close")

func spawn_drop_item() -> void:
	var rate = randf_range(0, 0.7)
	var drop_item: Node2D
	if rate > 0.2:
		var index = randi_range(1, 2)
		drop_item = drop_items[index].instantiate()
	else:
		drop_item = drop_items[0].instantiate()
	drop_item.position = position
	call_deferred("add_child", drop_item)

func _on_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		animation_player.play("open")
		var drop_probability = randf_range(0, 1)
		if drop_probability > 0.3:
			spawn_drop_item()
