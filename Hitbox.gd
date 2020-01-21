extends Area2D

func hide_hitboxes():
	for hitbox in get_children():
		hitbox.hide()