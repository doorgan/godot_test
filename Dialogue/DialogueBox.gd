extends CanvasLayer

var sequence : DialogueSequence
var current_dialogue_idx : int = 0


func _ready() -> void:
	$Control/Panel/NextLabel.text = "[" + InputMap.get_action_list("interact")[0].as_text() + "] Continue"


func start(sequence : DialogueSequence) -> void:
	self.sequence = sequence
	current_dialogue_idx = 0
	print_dialogue(sequence.dialogues[0])
	$Control.show()

func close() -> void:
	$Control.hide()

func print_dialogue(dialogue : Dialogue) -> void:
	$Control/Panel/Title.text = dialogue.title
	$Control/Panel/Text.text = dialogue.text

func next() -> void:
	if not sequence:
		return
	current_dialogue_idx += 1
	if current_dialogue_idx >= sequence.dialogues.size():
		DialogueManager.end()
		return
	var next_dialogue = sequence.dialogues[current_dialogue_idx]
	print_dialogue(next_dialogue)
