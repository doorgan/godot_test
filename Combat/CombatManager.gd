extends Node
class_name CombatManager

static func resolve_attack(attacker : Unit, target) -> void:
	var attack = {
		"damage": attacker.base_damage,
		"attacker": attacker
	}
	target.take_damage(attack)
