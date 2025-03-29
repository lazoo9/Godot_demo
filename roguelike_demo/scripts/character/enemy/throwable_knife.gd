extends HitBox
class_name ThrowableKnife

@onready var player: Player = get_tree().current_scene.get_node("Player")
@export var speed: int = 80
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	super()
	if is_instance_valid(player):
		look_at(player.global_position)
		dir = global_position.direction_to(player.global_position)
		knock_direction = global_position.direction_to(player.global_position)

func _physics_process(delta: float) -> void:
	position += dir * speed * delta

func on_body_entered(body: Node2D) -> void:
	super(body)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		queue_free()
