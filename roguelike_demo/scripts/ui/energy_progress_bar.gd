extends TextureProgressBar

@export var player: Player

func _ready() -> void:
	player.energy_change.connect(_on_player_energy_change)
	self.max_value = 1.0
	self.step = 0.0
	self.value = player.cur_energy / PlayerData.max_energy

func _on_player_energy_change(cur_energy: float, max_energy: float) -> void:
	var v = float(cur_energy) / float(max_energy)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", v, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
