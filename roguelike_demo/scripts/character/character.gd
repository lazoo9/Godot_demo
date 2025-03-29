extends CharacterBody2D
class_name Character

@onready var body: Node2D = $Body

@export var acceleration: int = 20
@export var friction: float = 0.15
@export var max_speed: int = 60
@export var flyable: bool = false

var move_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_slide()

func move(_delta: float) -> void:
	var dir = move_direction.normalized()
	velocity = dir * max_speed

func take_damage(_damage: int, _knock_dirention: Vector2, _knock_force: int) -> void:
	pass
