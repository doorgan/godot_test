extends CanvasLayer

var dialogue : Dialogue

func start(dialogue):
	dialogue = dialogue
	$Control/Panel/Title.text = dialogue.title
	$Control/Panel/Text.text = dialogue.text
	$Control.show()

func close():
	$Control.hide()
