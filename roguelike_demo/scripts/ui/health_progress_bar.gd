extends TextureProgressBar

@export var player: Player

func _ready() -> void:
	player.hp_change.connect(on_hp_change)
	self.max_value = 1.0
	self.step = 0.0
	self.value = float(player.cur_hp) / float(player.max_hp)

func on_hp_change(cur_hp: int, max_hp: int) -> void:
	var v = float(cur_hp) / float(max_hp)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", v, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
