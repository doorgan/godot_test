extends State

func physics_process(delta):
	if Input.is_action_just_pressed("roll"):
		emit_signal("finished", "roll")
	
	if Input.is_action_just_pressed("attack"):
		emit_signal("pushed", "attack1")
	
	var axis = owner.get_input_axis()
	if axis != Vector2.ZERO:
		emit_signal("finished", "run")

func enter():
	owner.play_animation("idle")