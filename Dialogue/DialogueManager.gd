extends Node

const Dialogue = preload("res://Dialogue/Dialogue.gd")
const DialogueBox = preload("res://Dialogue/DialogueBox.tscn")

var dialogue_box
var dialogue : Dialogue

func _ready():
	dialogue_box = DialogueBox.instance()
	get_tree().get_nodes_in_group("GUI")[0].add_child(dialogue_box)
	dialogue_box.close()

func start(_dialogue : Dialogue):
	dialogue = _dialogue
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.invulnerable = true
	dialogue_box.start(dialogue)

func end():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.invulnerable = false
	dialogue_box.close()
