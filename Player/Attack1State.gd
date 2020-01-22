extends State

var player
var should_attack = false
var attacked_entities = []
var can_chain = false

func handle_input(entity, event):
	if Input.is_action_just_pressed("attack"):
		if can_chain:
			entity.switch_state("attack2")

func enter(entity):
	player = entity
	entity.animations.travel("attack1")

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
	

func attack_started():
	should_attack = true;

func attack_finished():
	attacked_entities = []
	should_attack = false

func exit(entity):
	attack_finished()
	disable_chain()
	$Hitbox.hide_hitboxes()

func animation_finished():
	player.switch_state("idle")

func enable_chain():
	can_chain = true

func disable_chain():
	can_chain = false