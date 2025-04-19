extends Area2D
class_name Chest

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var drop_items: Array[PackedScene] = [
	preload("res://scenes/placement/bomb.tscn"),
	preload("res://scenes/placement/health_potion.tscn")
]

func _ready() -> void:
	animation_player.play("close")

func spawn_drop_item() -> void:
	var drop_item = drop_items.pick_random().instantiate()
	drop_item.position = position
	call_deferred("add_child", drop_item)

func _on_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		animation_player.play("open")
		var drop_probability = randf_range(0, 1)
		if drop_probability > 0.3:
			spawn_drop_item()
