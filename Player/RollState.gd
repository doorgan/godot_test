extends State

export var speed = 600
export var duration = 0.3

var direction = Vector2.ZERO

func enter():
	owner.play_animation("roll")
	$Timer.wait_time = duration
	$Timer.start()
	direction = owner.get_input_axis()
	if direction == Vector2.ZERO:
		direction = owner.facing

func physics_process(delta):
	var motion = owner.motion
	motion += direction.normalized() * speed * delta
	owner.move_and_collide(motion)

func exit():
	owner.motion = Vector2.ZERO

func _on_Timer_timeout():
	emit_signal("finished", "idle")
