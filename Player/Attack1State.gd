extends State

var player
var should_attack = false
var attacked_entities = []

func handle_input(entity, event):
	if Input.is_action_just_pressed("attack"):
		if !$Chain.is_stopped():
			entity.switch_state("attack2")

func enter(entity):
	player = entity
	entity.animations.travel("attack1")

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
			attacked_entities.append(target)
			target.hit_landed(entity)
	

func attack_started():
	should_attack = true;

func attack_finished():
	attacked_entities = []
	should_attack = false
	player.switch_state("idle")

func enable_chain():
	$Chain.start()

func disable_chain():
	$Chain.stop()