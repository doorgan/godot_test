extends Control

var dialogue : Dialogue

func start(dialogue):
	dialogue = dialogue
	$Panel/Title.text = dialogue.title
	$Panel/Text.text = dialogue.text
	show()

func close():
	hide()
