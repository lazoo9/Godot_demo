extends HitBox
class_name GroundSting

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	animation_player.play("active")

func on_body_entered(body: Node2D) -> void:
	if body.flyable:
		return
	knock_direction = get_global_mouse_position().direction_to(global_position)
	super(body)
