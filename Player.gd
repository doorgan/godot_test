extends KinematicBody2D

signal state_change(new_state)

var MAX_SPEED: float = 30
var ACCELERATION: float = 200
var motion: Vector2 = Vector2()
var facing: Vector2 = Vector2.RIGHT setget set_facing
var animations

func _ready():
	$AnimationTree.active = true
	animations = $AnimationTree.get("parameters/playback")
	$States.start()

func get_input_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func take_damage(attacker):
	print("Attacked by " + attacker.name)

func set_facing(new_dir):
	facing = new_dir
	if facing.x > 0:
		scale.x = scale.y * 1
	if facing.x < 0:
		scale.x = scale.y * -1

func play_animation(anim):
	$AnimationTree.get("parameters/playback").travel(anim)
