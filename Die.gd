extends State

var _entity : Node2D

func enter(entity):
	_entity = entity
	entity.animations.play("death")

func animation_finished():
	_entity.queue_free()