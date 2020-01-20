extends Area2D

func _on_Hurtbox_hit(attacker):
	print("Hit by: " + attacker.name)
