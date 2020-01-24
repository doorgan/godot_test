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

func exit(entity):
	$Cooldown.stop()

func physics_process(entity, delta):
	entity.move_and_slide(get_separation())
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

func get_separation() -> Vector2:
	var velocity : = Vector2.ZERO
	var neighbor_count : = 0
	
	for agent in _entity.get_node("Neighbors").get_overlapping_bodies():
		if (agent.is_in_group("player") or agent.is_in_group("enemy") or agent.is_in_group("environment")) \
			and agent.position.distance_to(_entity.position) < 20:
			velocity.x += agent.position.x - _entity.position.x
			velocity.y += agent.position.y - _entity.position.y
			neighbor_count += 1
	if neighbor_count == 0:
		return velocity
	
	velocity.x /= neighbor_count
	velocity.y /= neighbor_count
	
	velocity.x *= -1
	velocity.y *= -1
	
	velocity - Vector2(velocity.x - _entity.position.x, velocity.y - _entity.position.y)
	
	return velocity.normalized() * 15