extends Node2D

const Dialogue = preload("res://Dialogue/Dialogue.gd")

export (Resource) var dialogue

func _on_InteractionArea_body_entered(body):
	if body.is_in_group("player"):
		$Button.visible = true


func _on_InteractionArea_body_exited(body):
	if body.is_in_group("player"):
		$Button.visible = false

func _unhandled_input(event):
	if event.is_action_released("interact"):
		get_node("/root/Node/DialogueManager").start(dialogue)
