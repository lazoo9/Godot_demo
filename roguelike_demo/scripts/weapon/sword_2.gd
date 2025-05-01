extends Weapon
class_name Sword2

@onready var slash_hit_box: HitBox = $Slash/SlashHitBox

func move(move_direction: Vector2) -> void:
	super(move_direction)
	slash_hit_box.knock_direction = move_direction
