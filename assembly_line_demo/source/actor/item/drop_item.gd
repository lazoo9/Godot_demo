class_name DropItem
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var item: Item

func _ready() -> void:
	sprite_2d.texture = item.icon
	call_deferred("collect")

func collect() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.2)
	tween.set_parallel()
	tween.tween_property(self, "position:y", position.y - 10, 0.2)
	await tween.finished
	queue_free()
