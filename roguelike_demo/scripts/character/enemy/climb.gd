extends Enemy
class_name Climb

@onready var hit_box: HitBox = $Body/Sprite2D/HitBox

signal death

func _ready() -> void:
	super()
	if player:
		hit_box.knock_direction = global_position.direction_to(player.global_position)

func dead() -> void:
	death.emit()
	queue_free()
