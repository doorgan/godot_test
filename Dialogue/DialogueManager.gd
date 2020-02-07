extends Node

const Dialogue = preload("res://Dialogue/Dialogue.gd")
const DialogueBox = preload("res://Dialogue/DialogueBox.tscn")

var dialogue_box
var sequence : DialogueSequence
var active = false

func _ready():
	dialogue_box = DialogueBox.instance()
	get_tree().get_nodes_in_group("GUI")[0].add_child(dialogue_box)
	dialogue_box.close()

func start(sequence : DialogueSequence):
	InteractionManager.enabled = false
	sequence = sequence
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.add_effect(EffectInvulnerable)
		player.add_effect(EffectDisableInput)
	dialogue_box.start(sequence)
	active = true

func end():
	print("end dialogue!")
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.remove_effect(EffectInvulnerable)
		player.remove_effect(EffectDisableInput)
	dialogue_box.close()
	active = false
	yield(get_tree().create_timer(0.5), "timeout")
	InteractionManager.enabled = true


func _input(event):
	if not active:
		return

	if event.is_action_released("interact"):
		dialogue_box.next()
