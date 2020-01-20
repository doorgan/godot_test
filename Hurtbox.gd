extends Area2D
class_name Hurtbox

signal hit(attacker)

func hit_landed(attacker):
	print("hit landed")
	emit_signal("hit", attacker)