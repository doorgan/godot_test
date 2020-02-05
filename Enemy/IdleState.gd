extends State

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func physics_process(delta):
	var targets = owner.get_node("Perception").get_overlapping_bodies()
	for t in targets:
		if t.is_in_group("player") and not t.has_effect(EffectInvulnerable):
			owner.target = t
			emit_signal("finished", "chase")
			return
