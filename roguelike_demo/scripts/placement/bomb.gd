extends HitBox
class_name Bomb

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	animation_player.play("spawn_and_explode")
