extends Node

const Dialogue = preload("res://Dialogue/Dialogue.gd")

var dialogue : Dialogue

func start(_dialogue : Dialogue):
	dialogue = _dialogue
	$DialogueBox.start(dialogue)

func end():
	$DialogueBox.close()
