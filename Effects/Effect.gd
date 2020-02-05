extends Node
class_name Effect

export (String) var effect_name : String

func start() -> void:
	pass

func finish() -> void:
	queue_free()

func tick() -> void:
	pass
