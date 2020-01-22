extends State

var _entity

func enter(entity):
	_entity = entity

func _on_Perception_body_entered(body):
	if body.is_in_group("player"):
		_entity.target = body
		_entity.switch_state("chase")
