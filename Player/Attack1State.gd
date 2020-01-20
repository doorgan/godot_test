extends State

var player

func enter(entity):
	player = entity
	entity.animations.travel("attack1")

func attack_finished():
	player.switch_state("idle")