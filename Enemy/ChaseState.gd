extends State

var _entity : Node2D
var motion = Vector2.ZERO
var path: PoolVector2Array
var path_index : = 0
var velocity : = Vector2.ZERO
var steer : = Vector2.ZERO
var ahead : = Vector2.ZERO
var impact : = Vector2.ZERO
var normal : = Vector2.ZERO

var navigation: Navigation2D

func enter(entity):
	_entity = entity
	navigation = _entity.get_tree().get_nodes_in_group("navigation")[0]
	get_path()
	$Timer.start()

func exit(entity):
	motion = Vector2.ZERO
	$Timer.stop()

func physics_process(entity, delta):
	follow_path(delta)

func get_path():
	path_index = 0
	path = navigation.get_simple_path(_entity.global_position, _entity.target.global_position, false)
	update()

func follow_path(delta):
	if !path:
		return
	var goal = path[path_index]
	if _entity.global_position.distance_to(goal) < 1:
		path_index = wrapi(path_index + 1, 0, path.size())
		goal = path[path_index]
	velocity = Vector2.ZERO
	velocity = (goal - _entity.global_position).normalized() * 20
	
	var space = _entity.get_world_2d().direct_space_state
	ahead = _entity.global_position + velocity * 1.5
	var result = space.intersect_ray(ahead, goal, [_entity])
	if result and not result.collider.is_in_group("player"):
		impact = result.position
		normal = result.normal
		var length = (ahead - impact).length()
		steer = (ahead - (normal * length)).normalized() * 20
	else:
		steer = Vector2.ZERO
	
	motion = _entity.move_and_collide((velocity + steer) * delta)
	update()

func _on_Perception_body_exited(body):
	if body.is_in_group("player"):
		_entity.switch_state("idle")

func _draw():
	if not _entity:
		return
	draw_path()
	draw_circle(pos_of(ahead), 2, Color.cyan)
	draw_circle(pos_of(impact), 5, Color.black)
#	draw_line(Vector2.ZERO, motion, Color.yellow)
	draw_line(Vector2.ZERO, velocity, Color.yellow)
	draw_line(Vector2.ZERO, steer, Color.purple)
	draw_line(Vector2.ZERO, velocity + steer, Color.black)
	draw_line(pos_of(impact), pos_of(impact + normal), Color.blue)

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
