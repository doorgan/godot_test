extends State

func enter():
	owner.animations.play("death")

func animation_finished():
	owner.remove()