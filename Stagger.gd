extends State

export (float) var STAGGER_TIME = 0.6
export (int) var STAGGER_KNOCKBACK_SPEED = 10

func enter():
	owner.staggered = true
	owner.animations.play("stagger")
	$Timer.wait_time = STAGGER_TIME
	$Timer.start()

func exit():
	owner.staggered = false
	$Timer.stop()

func physics_process(delta):
	var direction = owner.last_attacker.position.direction_to(owner.position)
	owner.velocity = owner.move_and_slide(direction * STAGGER_KNOCKBACK_SPEED)

func _on_Timer_timeout():
	emit_signal("finished", "idle")
