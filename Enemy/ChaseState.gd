extends State

export (bool) var DEBUG = false

export (int) var ACCELERATION = 50
export (int) var MASS = 20
export (int) var ATTACK_RANGE = 25

var _entity : Node2D
var path: PoolVector2Array
var path_index : = 0
var velocity : = Vector2.ZERO
var steer : = Vector2.ZERO
var separation : = Vector2.ZERO

var navigation: Navigation2D

func enter(entity):
	_entity = entity
	navigation = _entity.get_tree().get_nodes_in_group("navigation")[0]
	get_path()
	$Timer.start()
	_entity.animations.play("chase")

func exit(entity):
	_entity.velocity = Vector2.ZERO
	$Timer.stop()

func physics_process(entity, delta):
	if _entity.position.distance_to(_entity.target.position) <= ATTACK_RANGE:
		_entity.switch_state("attack")
	else:
		follow_path(delta)
		entity.facing = entity.velocity

func get_path():
	path_index = 0
	path = navigation.get_simple_path(_entity.global_position, _entity.target.global_position)
	update()

func follow_path(delta):
	steer = path_follow()
	steer += get_separation()
	
	_entity.velocity = _entity.move_and_slide(_entity.velocity + steer)
	update()

func get_separation() -> Vector2:
	var velocity : = Vector2.ZERO
	var neighbor_count : = 0
	
	for agent in _entity.get_node("Neighbors").get_overlapping_bodies():
		if agent.is_in_group("enemy") or agent.is_in_group("environment"):
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
	
	separation = velocity.normalized() * MASS
	
	return velocity.normalized()

func path_follow():
	if !path:
		return Vector2.ZERO
	var goal = path[path_index]
	if _entity.global_position.distance_to(goal) <= 10:
		path_index += 1
		if path_index >= path.size():
			path_index = path.size() - 1
	if goal:
		return seek(goal)
	else:
		return Vector2.ZERO

func seek(
		target : Vector2
	) -> Vector2:
	var pos = _entity.global_position
	var desired_velocity = (target - pos).normalized() * ACCELERATION
	var steering = (desired_velocity - _entity.velocity) / MASS
	return steering

func _on_Perception_body_exited(body):
	if body.is_in_group("player"):
		_entity.switch_state("idle")

func _draw():
	if not DEBUG:
		return
	if not _entity:
		return
	draw_path()
	draw_line(Vector2.ZERO, _entity.velocity, Color.yellow)
	draw_line(Vector2.ZERO, steer, Color.purple)
	draw_line(Vector2.ZERO, _entity.velocity + steer, Color.black)
	draw_line(Vector2.ZERO, separation, Color.blue, 2)

func draw_path():
	for i in range(path.size()):
		if i < path.size() - 1:
			if i == 0:
				draw_line(Vector2.ZERO, pos_of(path[i]), Color.red)
			else:
				draw_line(pos_of(path[i]), pos_of(path[i+1]), Color.red)

func pos_of(vector : Vector2) -> Vector2:
	return vector - _entity.global_position

func _on_Timer_timeout():
	get_path()
