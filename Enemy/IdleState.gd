extends State

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func _on_Perception_body_entered(body):
	if body.is_in_group("player"):
		owner.target = body
		emit_signal("finished", "chase")
