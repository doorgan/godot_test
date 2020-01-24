extends KinematicBody2D
class_name Agent

export (int) var MASS = 20
export (int) var ACCELERATION = 50

var velocity : = Vector2.ZERO

var path_index : = 0

onready var neighbors : Area2D = $Neighbors

func seek(
		target : Vector2
	) -> Vector2:
	var pos = global_position
	var desired_velocity = (target - pos).normalized() * ACCELERATION
	var steering = (desired_velocity - velocity) / MASS
	return steering

func get_separation() -> Vector2:
	var steering : = Vector2.ZERO
	var neighbor_count : = 0
	
	for body in neighbors.get_overlapping_bodies():
		if body is Agent:
			steering.x += body.position.x - position.x
			steering.y += body.position.y - position.y
			neighbor_count += 1
	if neighbor_count == 0:
		return velocity
	
	steering.x /= neighbor_count
	steering.y /= neighbor_count
	
	steering.x *= -1
	steering.y *= -1
	
	steering - Vector2(steering.x - position.x, steering.y - position.y)
	
	return steering.normalized()

func follow_path(path):
	if !path:
		return Vector2.ZERO
	var goal = path[path_index]
	if global_position.distance_to(goal) <= 10:
		path_index += 1
		if path_index >= path.size():
			path_index = path.size() - 1
	if goal:
		return seek(goal)
	else:
		return Vector2.ZERO