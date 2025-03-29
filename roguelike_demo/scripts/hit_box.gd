extends Area2D
class_name HitBox

@onready var collision_shape: CollisionShape2D = self.get_node("CollisionShape2D")

@export var damage: int = 1
@export var knock_force: int = 30
var knock_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	assert(collision_shape != null)
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if is_instance_valid(body) and body.has_method("take_damage"):
		body.take_damage(damage, knock_direction, knock_force)
