extends State

var should_attack = false
var attacked_entities = []
var can_chain = false

func enter():
	owner.animations.travel("attack3")

func physics_process(delta):
	if not should_attack:
		return
	var targets = $Hitbox.get_overlapping_areas()
	for target in targets:
		if target is Hurtbox:
			if owner.is_a_parent_of(target):
				continue
			if attacked_entities.has(target):
				continue
			attacked_entities.append(target)
			target.hit_landed(owner)

func exit():
	attack_finished()
	$Hitbox.hide_hitboxes()

func attack_started():
	should_attack = true;

func attack_finished():
	attacked_entities = []
	should_attack = false

func animation_finished():
	emit_signal("finished", "idle")

func enable_chain():
	can_chain = true

func disable_chain():
	can_chain = false