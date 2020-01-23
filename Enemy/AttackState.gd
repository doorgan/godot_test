extends State

var _entity : Object
var attacked_entities : Array
var animations : AnimationPlayer
var should_attack : = false

const ATTACK_COOLDOWN = 1

func enter(entity):
	_entity = entity
	_entity.animations.seek(0)
	_entity.animations.play("attack")
	$Cooldown.wait_time = ATTACK_COOLDOWN
	_entity.facing = _entity.position.direction_to(_entity.target.position)

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

func attack_start():
	should_attack = true
	attacked_entities = []

func attack_end():
	should_attack = false
	attacked_entities = []

func finnish_attack():
	$Cooldown.start()

func _on_Cooldown_timeout():
	_entity.switch_state("chase")
