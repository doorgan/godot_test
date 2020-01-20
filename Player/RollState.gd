extends State

export var speed = 600
export var duration = 0.3

var ent

func enter(entity):
	ent = entity
	entity.animations.travel("roll")
	$Timer.wait_time = duration
	$Timer.start()

func update(entity, delta):
	var motion = entity.motion
	motion += entity.facing.normalized() * speed * delta
	entity.move_and_collide(motion)

func exit(entity):
	entity.motion = Vector2.ZERO

func _on_Timer_timeout():
	ent.switch_state("idle")
