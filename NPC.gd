extends Node2D

const Dialogue = preload("res://Dialogue/Dialogue.gd")

export (Resource) var sequence

var action_text = "Talk"

func _on_InteractionArea_body_entered(body):
	if body.is_in_group("player"):
		InteractionManager.add_interactable(self)

func _on_InteractionArea_body_exited(body):
	if body.is_in_group("player"):
		InteractionManager.remove_interactable(self)


func on_interact():
	DialogueManager.start(sequence)
