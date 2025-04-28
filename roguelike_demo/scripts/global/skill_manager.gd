extends Node

func activate_skill(skill_resource: SkillResource) -> void:
	skill_resource.active = true
	PlayerData.activated_skills.append(skill_resource.id)
	PlayerData.skill_point_num -= skill_resource.cost
	match skill_resource.effect_type:
		SkillResource.EFFECT_TYPE.add_max_hp:
			PlayerData.max_hp += skill_resource.effect_value
			Game.player.cur_hp = PlayerData.max_hp
		SkillResource.EFFECT_TYPE.add_max_energy:
			PlayerData.max_energy += skill_resource.effect_value
			Game.player.cur_energy = PlayerData.max_energy
		SkillResource.EFFECT_TYPE.unlock_heavy_attack:
			PlayerData.can_heavy_attack = true
