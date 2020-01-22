extends State

var player
var should_attack = false
var attacked_entities = []
var can_chain = false

func enter(entity):
	player = entity
	entity.animations.travel("attack3")

func physics_process(entity, delta):
	if not should_attack:
		return
	var targets = $Hitbox.get_overlapping_areas()
	for target in targets:
		if target is Hurtbox:
			if entity.is_a_parent_of(target):
				continue
			if attacked_entities.has(target):
				continue
			attacked_entities.append(target)
			target.hit_landed(entity)

func exit(entity):
	attack_finished()
	$Hitbox.hide_hitboxes()

func attack_started():
	should_attack = true;

func attack_finished():
	attacked_entities = []
	should_attack = false

func animation_finished():
	player.switch_state("idle")

func enable_chain():
	can_chain = true

func disable_chain():
	can_chain = false