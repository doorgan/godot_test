extends Node

const InteractionTooltip = preload("res://Interactions/InteractionTooltip.tscn")
var interaction_tooltip

var interactables : Array = []
var enabled = true


func _ready():
	interaction_tooltip = InteractionTooltip.instance()
#	interaction_tooltip.hide()
	get_tree().get_nodes_in_group("GUI")[0].add_child(interaction_tooltip)


func add_interactable(interactable) -> void:
	interactables.append(interactable)
	update_text()


func remove_interactable(interactable) -> void:
	interactables.erase(interactable)
	update_text()


# Cycles to the next interactable
func next() -> void:
	if interactables.size() == 0:
		return
	var first = interactables.pop_front()
	add_interactable(first)


func update_text() -> void:
	if interactables.size() < 1:
		interaction_tooltip.hide()
		return
	print(interactables.front())
	interaction_tooltip.show()
	interaction_tooltip.get_node("Panel/Label").text = \
		interactables.front().action_text


func _unhandled_input(event):
	if !enabled or interactables.size() == 0:
		return
	if event.is_action_released("interact"):
		interactables.front().on_interact()
