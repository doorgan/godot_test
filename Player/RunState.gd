extends State

export var speed = 150

func handle_input(entity, event):
	if Input.is_action_just_pressed("roll"):
		entity.switch_state("roll")
	
	if Input.is_action_just_pressed("attack"):
		entity.switch_state("attack1")

func physics_process(entity, delta):
	var axis = entity.get_input_axis()
	if axis == Vector2.ZERO:
		entity.motion = Vector2.ZERO
		entity.switch_state("idle")
	else:
		entity.facing = axis.normalized()
		var motion = entity.motion
		motion += axis.normalized() * speed * delta
		entity.move_and_collide(motion)

		if entity.facing.x > 0:
			entity.scale.x = entity.scale.y * 1
		if entity.facing.x < 0:
			entity.scale.x = entity.scale.y * -1

		if motion == Vector2.ZERO:
			entity.switch_state("idle")

func enter(entity):
	entity.animations.travel("run")