extends KinematicBody2D
class_name Unit

export (NodePath) var effects_slot : NodePath

onready var EffectsSlot : Node = get_node(effects_slot)

var effects : = []

func _ready():
	assert(effects_slot)


func add_effect(effect : Node) -> void:
	# TODO: use an Effect node as type
	# TODO: check duplicates
	EffectsSlot.add_child(effect)


# Removes the effect from the unit.
# Should take a Node, a NodePath or a custom resource?
func remove_effect(effect_name : NodePath) -> void:
	EffectsSlot.get_node(effect_name).finish()

# Returns the current active effects on the unit
# Should return an array of nodes or an array of custom resources?
func get_active_effects() -> Array:
	return EffectsSlot.get_children()

func has_effect(effect_name):
	for effect in get_active_effects():
		if effect.name == effect_name:
			return true
	return false
