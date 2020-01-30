extends KinematicBody2D
class_name Agent

var _agent : KinematicBody2D
var _mass : = 20
var _acceleration : = 50
var _path_index : = 0

onready var neighbors : Area2D = $Neighbors

func _init(
		agent: KinematicBody2D,
		acceleration : = 50,
		mass : = 20
	) -> void:
	_agent = agent
	_acceleration = acceleration
	_mass = mass

func seek(
		target : Vector2,
		acceleration : = _acceleration,
		mass : = _mass
	) -> Vector2:
	var pos = _agent.global_position
	var desired_velocity = (target - pos).normalized() * acceleration
	var steering = (desired_velocity - _agent.velocity) / mass
	return steering

func get_separation(
		area : Area2D
	) -> Vector2:
	var steering : = Vector2.ZERO
	var neighbor_count : = 0
	
	for body in area.get_overlapping_bodies():
		steering.x += body.position.x - _agent.position.x
		steering.y += body.position.y - _agent.position.y
		neighbor_count += 1
	if neighbor_count == 0:
		return _agent.velocity
	
	steering.x /= neighbor_count
	steering.y /= neighbor_count
	
	steering.x *= -1
	steering.y *= -1
	
	steering - Vector2(steering.x - _agent.position.x, steering.y - _agent.position.y)
	
	return steering.normalized()

func follow_path(
	path : PoolVector2Array
	) -> Vector2:
	if !path:
		return Vector2.ZERO
	var goal = path[_path_index]
	if _agent.global_position.distance_to(goal) <= 10:
		_path_index += 1
		if _path_index >= path.size():
			_path_index = path.size() - 1
	if goal:
		return seek(goal)
	else:
		return Vector2.ZERO
