extends State

func update(entity, delta):
	if Input.is_action_just_pressed("roll"):
		entity.switch_state("roll")
	
	if Input.is_action_just_pressed("attack"):
		entity.switch_state("attack1")
	
	var axis = entity.get_input_axis()
	if axis != Vector2.ZERO:
		entity.switch_state("run")

func enter(entity):
	entity.animations.travel("idle")