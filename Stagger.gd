extends State

var _entity : KinematicBody2D

export (float) var STAGGER_TIME = 0.6
export (int) var STAGGER_KNOCKBACK_SPEED = 10

func enter(entity):
	_entity = entity
	_entity.animations.play("stagger")
	$Timer.wait_time = STAGGER_TIME
	$Timer.start()

func physics_process(entity, delta):
	var direction = entity.last_attacker.position.direction_to(entity.position)
	entity.velocity = entity.move_and_slide(direction * STAGGER_KNOCKBACK_SPEED)

func _on_Timer_timeout():
	_entity.to_previous_state()
