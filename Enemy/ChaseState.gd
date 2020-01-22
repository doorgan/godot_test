extends State

var _entity
var motion = Vector2.ZERO
var velocity = Vector2.ZERO
var steer = Vector2.ZERO
var ahead = Vector2.ZERO
var ahead2 = Vector2.ZERO
var obstacle = Vector2.ZERO

func enter(entity):
	print("CHASING!")
	_entity = entity

func exit(entity):
	motion = Vector2.ZERO

func physics_process(entity, delta):
	velocity = Vector2.ZERO
	velocity = (_entity.target.position - _entity.position).normalized() * 20
	ahead = _entity.position + velocity.normalized() * 60
	ahead2 = _entity.position + velocity.normalized() * 30
	var space_state = get_world_2d().direct_space_state
	var intersection = space_state.intersect_ray(\
		_entity.position, destination, [_entity])
	if intersection and not intersection.collider.is_in_group("player"):
		obstacle = intersection.position
		steer = obstacle - destination
		steer = steer.normalized()
		steer *= 20
		velocity += steer
	else:
		steer = Vector2.ZERO
	motion = entity.move_and_slide(velocity)
	update()

func _on_Perception_body_exited(body):
	if body.is_in_group("player"):
		_entity.switch_state("idle")

func _draw():
	if _entity:
		draw_line(Vector2.ZERO, velocity, Color(255, 0, 0))
		draw_line(Vector2.ZERO, motion, Color(255, 255, 255))
		draw_line(Vector2.ZERO, steer, Color(255, 0, 255))
		draw_circle(destination - _entity.position, 5, Color(0, 255, 255))
		
	if obstacle:
		draw_circle(obstacle - _entity.position, 5, Color(0, 255, 255))