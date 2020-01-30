extends Area2D

signal parried(defender)

func hide_hitboxes():
	for hitbox in get_children():
		hitbox.hide()
