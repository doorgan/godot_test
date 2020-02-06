extends KinematicBody2D
class_name Unit

export (int) var max_health : int = 100
var health : int = max_health

export (int) var movement_speed : int = 200

export (int) var base_damage : int = 5

export (NodePath) var effects_slot : NodePath
onready var EffectsSlot : Node = get_node(effects_slot)

var effects : = []

func _ready():
	assert(effects_slot)


######## ######## ######## ########  ######  ########  ######  
##       ##       ##       ##       ##    ##    ##    ##    ## 
##       ##       ##       ##       ##          ##    ##       
######   ######   ######   ######   ##          ##     ######  
##       ##       ##       ##       ##          ##          ##
##       ##       ##       ##       ##    ##    ##    ##    ## 
######## ##       ##       ########  ######     ##     ######  


# Adds an effect to the unit
func add_effect(effect_type: GDScript) -> void:
	# TODO: check duplicates?
	var effect : Effect = effect_type.new()
	EffectsSlot.add_child(effect)


# Removes the effect from the unit.
func remove_effect(effect_type : GDScript) -> void:
	var effect : = get_effect(effect_type)
	if effect:
		effect.finish()

# Returns the current active effects on the unit
# Should return an array of nodes or an array of custom resources?
func get_active_effects() -> Array:
	return EffectsSlot.get_children()


# Checks if the unit has an effect of the given type
func has_effect(effect_type : GDScript) -> bool:
	var effect = get_effect(effect_type)
	if effect:
		return true
	else:
		return false


# Gets an effect of the given type or nulls if it doesn't find one
func get_effect(effect_type : GDScript) -> Effect:
	for effect in get_active_effects():
		if effect is effect_type:
			return effect
	return null
