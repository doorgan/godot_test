extends State

export (bool) var DEBUG = false

export (int) var ACCELERATION = 50
export (int) var MASS = 20
export (int) var ATTACK_RANGE = 30
export (int) var STRAFE_RANGE = 45
export (int) var STRAFE_VELOCITY = 20

var agent : Agent

var path: PoolVector2Array
var path_index : = 0
var velocity : = Vector2.ZERO
var steer : = Vector2.ZERO
var separation : = Vector2.ZERO

enum StrafeDirection {CW, CCW}
var strafe_direction = StrafeDirection.CW

var navigation: Navigation2D

enum {
	CHASING,
	STRAFING,
	TAKING_DISTANCE,
	FINISHED
}

var state = CHASING

func enter():
	if not owner.target:
		emit_signal("finished", "idle")
	navigation = owner.get_tree().get_nodes_in_group("navigation")[0]
	get_path()
	$Timer.start()
	owner.animations.play("chase")

func exit():
	owner.velocity = Vector2.ZERO
	$Timer.stop()

func physics_process(delta):
	if owner.target.has_effect(EffectInvulnerable):
		return emit_signal("finished", "idle")
	var distance_to_target = owner.position.distance_to(owner.target.position)
	var direction_to_target = owner.position.direction_to(owner.target.position)

	if distance_to_target > ATTACK_RANGE:
		state = CHASING
	
	if owner.target.is_shielding \
		and distance_to_target <= STRAFE_RANGE \
		and sign(owner.facing.x) != sign(owner.target.facing.x):
		state = STRAFING
		if distance_to_target < STRAFE_RANGE * 0.75:
			state = TAKING_DISTANCE
	
	if distance_to_target <= ATTACK_RANGE \
		and ( \
		!owner.target.is_shielding \
		or sign(owner.facing.x) == sign(owner.target.facing.x)
		):
		state = FINISHED
	
	print(state)

	match state:
		CHASING:
			follow_path(delta)
			owner.facing = owner.velocity
		STRAFING:
			strafe()
		TAKING_DISTANCE:
			take_distance()
		FINISHED:
			emit_signal("finished", "attack")
	print(distance_to_target)

func strafe():
	steer = get_strafe_vector()
	owner.velocity = owner.move_and_slide(steer * STRAFE_VELOCITY)
	owner.facing = owner.position.direction_to(owner.target.position)

func take_distance():
	var direction = owner.position.direction_to(owner.target.position)
	owner.velocity = owner.move_and_slide(-direction * STRAFE_VELOCITY)
	owner.facing = direction

func get_strafe_vector() -> Vector2:
	var dir = owner.position.direction_to(owner.target.position)
	
	if $StrafeTimer.is_stopped():
		var cw = rand_range(0, 1) > 0.5
		if cw:
			strafe_direction = StrafeDirection.CW
		else:
			strafe_direction = StrafeDirection.CCW
		
		$StrafeTimer.start()
	
	var strafe : Vector2
	if strafe_direction == StrafeDirection.CW:
		strafe = Vector2(dir.y, -dir.x)
	else:
		strafe = Vector2(-dir.y, dir.x)
	
	return strafe.normalized()

func get_path():
	agent = Agent.new(owner)
	path = navigation.get_simple_path(owner.global_position, owner.target.global_position)
	update()

# warning-ignore:unused_argument
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
