extends State

var _entity
var motion = Vector2.ZERO

func enter(entity):
	print("CHASING!")
	_entity = entity

func exit(entity):
	motion = Vector2.ZERO

func update(entity, delta):
	motion = Vector2.ZERO
	motion = (_entity.target.position - _entity.position).normalized() * 25
	motion = entity.move_and_slide(motion)

func _on_Perception_body_exited(body):
	if body.is_in_group("player"):
		_entity.switch_state("idle")
