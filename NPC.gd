extends Node2D

const Dialogue = preload("res://Dialogue/Dialogue.gd")

export (Resource) var sequence

var can_interact : bool = false

func _on_InteractionArea_body_entered(body):
	if body.is_in_group("player"):
		can_interact = true
		$Button.visible = true


func _on_InteractionArea_body_exited(body):
	if body.is_in_group("player"):
		can_interact = false
		$Button.visible = false
		DialogueManager.end()


func _unhandled_input(event):
	if event.is_action_released("interact") and can_interact:
		DialogueManager.start(sequence)
