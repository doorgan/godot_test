extends State

export (bool) var DEBUG = false

export (int) var ACCELERATION = 50
export (int) var MASS = 20
export (int) var ATTACK_RANGE = 25

var agent : Agent

var path: PoolVector2Array
var path_index : = 0
var velocity : = Vector2.ZERO
var steer : = Vector2.ZERO
var separation : = Vector2.ZERO

var navigation: Navigation2D

func enter():
	navigation = owner.get_tree().get_nodes_in_group("navigation")[0]
	get_path()
	$Timer.start()
	owner.animations.play("chase")

func exit():
	owner.velocity = Vector2.ZERO
	$Timer.stop()

func physics_process(delta):
	if owner.position.distance_to(owner.target.position) > ATTACK_RANGE:
		follow_path(delta)
		owner.facing = owner.velocity
	else:
		if not owner.target.is_shielding:
			emit_signal("finished", "attack")

func get_path():
	agent = Agent.new(owner)
	path = navigation.get_simple_path(owner.global_position, owner.target.global_position)
	update()

func follow_path(delta):
	steer = agent.follow_path(path)
	steer += agent.get_separation(owner.get_node("Neighbors"))
	
	owner.velocity = owner.move_and_slide(owner.velocity + steer)
	update()

func _on_Perception_body_exited(body):
	if body.is_in_group("player"):
		emit_signal("finished", "idle")

func _draw():
	if not DEBUG:
		return
	if not owner:
		return
	draw_path()
	draw_line(Vector2.ZERO, owner.velocity, Color.yellow)
	draw_line(Vector2.ZERO, steer, Color.purple)
	draw_line(Vector2.ZERO, owner.velocity + steer, Color.black)
	draw_line(Vector2.ZERO, separation, Color.blue, 2)

func draw_path():
	for i in range(path.size()):
		if i < path.size() - 1:
			if i == 0:
				draw_line(Vector2.ZERO, pos_of(path[i]), Color.red)
			else:
				draw_line(pos_of(path[i]), pos_of(path[i+1]), Color.red)

func pos_of(vector : Vector2) -> Vector2:
	return vector - owner.global_position

func _on_Timer_timeout():
	get_path()
