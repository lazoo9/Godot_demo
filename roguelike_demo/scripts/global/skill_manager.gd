extends Node

func activate_skill(skill_resource: SkillResource) -> void:
	skill_resource.active = true
	PlayerData.activated_skills.append(skill_resource.id)
	match skill_resource.effect_type:
		SkillResource.EFFECT_TYPE.add_max_hp:
			pass
		SkillResource.EFFECT_TYPE.add_max_energy:
			pass
		SkillResource.EFFECT_TYPE.unlock_heavy_attack:
			pass
