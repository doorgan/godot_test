extends State

export var speed = 600
export var duration = 0.3

func enter():
	owner.play_animations("roll")
	$Timer.wait_time = duration
	$Timer.start()

func physics_process(delta):
	var motion = owner.motion
	motion += owner.facing.normalized() * speed * delta
	owner.move_and_collide(motion)

func exit():
	owner.motion = Vector2.ZERO

func _on_Timer_timeout():
	emit_signal("finished", "idle")
