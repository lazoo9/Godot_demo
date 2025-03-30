extends Enemy
class_name Smile

@onready var hit_box: HitBox = $Body/Sprite2D/HitBox

func _physics_process(delta: float) -> void:
	super(delta)
	if player:
		hit_box.knock_direction = global_position.direction_to(player.global_position)
