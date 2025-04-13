extends Area2D
class_name HitBox

@onready var collision_shape: CollisionShape2D = self.get_node("CollisionShape2D")
@onready var player: Player = get_tree().current_scene.get_node("Player")

@export var damage: int = 1
@export var knock_force: int = 30
var knock_direction: Vector2 = Vector2.ZERO
var player_enter: bool = false
var timer: Timer = Timer.new()

func _ready() -> void:
	assert(collision_shape != null)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	timer.wait_time = 1.0
	timer.timeout.connect(on_timeout)
	add_child(timer)

func on_body_entered(body: Node2D) -> void:
	if is_instance_valid(body) and body.has_method("take_damage"):
		take_damage(body)
		player_enter = true
		timer.start()

func on_body_exited(_body: Node2D) -> void:
	player_enter = false
	timer.stop()

func on_timeout() -> void:
	if overlaps_body(player) and player_enter:
		if is_instance_valid(player):
			take_damage(player)
	else:
		player_enter = false

func take_damage(body: Node2D) -> void:
	if body is WizardBoss:
		body.take_damage(damage, Vector2.ZERO, 0)
	else:
		body.take_damage(damage, knock_direction, knock_force)
