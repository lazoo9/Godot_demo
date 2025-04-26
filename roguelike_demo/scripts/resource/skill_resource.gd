extends Resource
class_name SkillResource

enum EFFECT_TYPE {
	add_max_hp,
	add_max_energy,
	unlock_heavy_attack,
}

@export var id: int
@export var active: bool
@export var effect_type: EFFECT_TYPE
@export var effect_value: Variant = 1
@export var cost: String
@export var icon: Texture2D
@export var description: String
@export var required_skill: Array[SkillResource]
