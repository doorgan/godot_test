extends State

var player
var should_attack = false
var attacked_entities = []

func enter(entity):
	player = entity
	entity.animations.travel("attack2")

func update(entity, delta):
	if not should_attack:
		return
	var targets = $Hitboxes.get_overlapping_areas()
	for target in targets:
		if target is Hurtbox:
			if entity.is_a_parent_of(target):
				break
			if attacked_entities.has(target):
				break
			print(target)
			attacked_entities.append(target)
			target.hit_landed(entity)
	

func attack_started():
	should_attack = true;

func attack_finished():
	attacked_entities = []
	should_attack = false
	player.switch_state("idle")