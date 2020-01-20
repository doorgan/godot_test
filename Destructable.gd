extends Area2D



func _on_Hurtbox_area_entered(area):
	if(!area.disabled):
		print("hit")
