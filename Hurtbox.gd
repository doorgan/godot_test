extends Area2D
class_name Hurtbox

signal hit(attacker)

func hit_landed(attacker):
	emit_signal("hit", attacker)
