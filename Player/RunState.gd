extends State

func handle_input(event):
	if Input.is_action_just_pressed("roll"):
		emit_signal("finished", "roll")
	
	if Input.is_action_just_pressed("attack"):
		emit_signal("pushed", "attack1")


func physics_process(delta):
	var axis = owner.get_input_axis()
	if axis == Vector2.ZERO:
		owner.motion = Vector2.ZERO
		emit_signal("finished", "idle")
	else:
		owner.facing = axis.normalized()
		var motion = owner.motion
		motion += axis.normalized() * owner.movement_speed * delta
		owner.move_and_collide(motion)

		if motion == Vector2.ZERO:
			emit_signal("finished", "idle")


func enter():
	owner.play_animation("run")
