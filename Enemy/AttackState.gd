extends State

var attacked_entities : Array
var animations : AnimationPlayer
var should_attack : = false

const ATTACK_COOLDOWN = 1

func enter():
	owner = owner
	owner.animations.seek(0)
	owner.animations.play("attack")
	$Cooldown.wait_time = ATTACK_COOLDOWN
	owner.facing = owner.position.direction_to(owner.target.position)

func exit():
	$Cooldown.stop()

func physics_process(delta):
	owner.move_and_slide(get_separation())
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

func attack_start():
	should_attack = true
	attacked_entities = []

func attack_end():
	should_attack = false
	attacked_entities = []

func finnish_attack():
	$Cooldown.start()

func _on_Cooldown_timeout():
	emit_signal("finished", "chase")

func get_separation() -> Vector2:
	var velocity : = Vector2.ZERO
	var neighbor_count : = 0
	
	for agent in owner.get_node("Neighbors").get_overlapping_bodies():
		if (agent.is_in_group("player") or agent.is_in_group("enemy") or agent.is_in_group("environment")) \
			and agent.position.distance_to(owner.position) < 20:
			velocity.x += agent.position.x - owner.position.x
			velocity.y += agent.position.y - owner.position.y
			neighbor_count += 1
	if neighbor_count == 0:
		return velocity
	
	velocity.x /= neighbor_count
	velocity.y /= neighbor_count
	
	velocity.x *= -1
	velocity.y *= -1
	
	velocity - Vector2(velocity.x - owner.position.x, velocity.y - owner.position.y)
	
	return velocity.normalized() * 15