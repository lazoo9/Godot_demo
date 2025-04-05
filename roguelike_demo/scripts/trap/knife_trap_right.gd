extends Node2D

@onready var shoot_position: Marker2D = $ShootPosition
@onready var shoot_timer: Timer = $ShootTimer

var knife_scene: PackedScene = preload("res://scenes/character/enemy/throwable_knife.tscn")

func _ready() -> void:
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _on_shoot_timer_timeout() -> void:
	var knife = knife_scene.instantiate() as ThrowableKnife
	add_child(knife)
	knife.global_position = shoot_position.global_position
	knife.look_at(Vector2.LEFT)
	#knife.rotation = 180
	print(knife.rotation)
	knife.dir = Vector2.LEFT
