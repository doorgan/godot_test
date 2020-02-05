extends Node
class_name Effects

static func create_effect(effect_type : GDScript) -> Effect:
	return effect_type.new()
