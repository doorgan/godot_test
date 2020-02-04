extends CanvasLayer

var sequence : DialogueSequence

func start(sequence : DialogueSequence) -> void:
	sequence = sequence
	print_dialogue(sequence.dialogues[0])
	$Control.show()

func close() -> void:
	$Control.hide()

func print_dialogue(dialogue : Dialogue) -> void:
	$Control/Panel/Title.text = dialogue.title
	$Control/Panel/Text.text = dialogue.text
