extends Node2D

const Dialogue = preload("res://Dialogue/Dialogue.gd")

export (Resource) var sequence

func _on_InteractionArea_body_entered(body):
	if body.is_in_group("player"):
		$Button.visible = true


func _on_InteractionArea_body_exited(body):
	if body.is_in_group("player"):
		$Button.visible = false
		DialogueManager.end()


func _unhandled_input(event):
	if event.is_action_released("interact"):
		DialogueManager.start(sequence)
