extends TextureRect
class_name  WeaponSlot

@onready var reference_rect: ReferenceRect = $ReferenceRect

func initialize(text: Texture2D) -> void:
	self.texture = text

func select() -> void:
	reference_rect.show()

func deselect() -> void:
	reference_rect.hide()
