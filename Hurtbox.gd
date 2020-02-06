extends Area2D
class_name Hurtbox

signal hit(attacker)

func hit_landed(attacker):
	CombatManager.resolve_attack(attacker, owner)
#	emit_signal("hit", attacker)
