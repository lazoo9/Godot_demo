extends HitBox
class_name Throwable

@export var speed: int = 80
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	position += dir * speed * delta

func to_player() -> void:
	if is_instance_valid(player):
		look_at(player.global_position)
		dir = global_position.direction_to(player.global_position)
		knock_direction = global_position.direction_to(player.global_position)

func set_dir(direction: Vector2) -> void:
	dir = direction
	knock_direction = direction

func on_body_entered(body: Node2D) -> void:
	super(body)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		print(area)
		queue_free()
