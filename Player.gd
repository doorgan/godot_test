extends KinematicBody2D

signal state_change(new_state)

var MAX_SPEED: float = 30
var ACCELERATION: float = 200
var motion: Vector2 = Vector2()
var facing: Vector2 = Vector2.RIGHT
var animations

onready var states = {
	"idle": $States/Idle,
	"run": $States/Run,
	"roll": $States/Roll,
	"attack1": $States/Attack,
	"attack2": $States/Attack2,
	"attack3": $States/Attack3
}
onready var state = states["idle"]

func _physics_process(delta):
	state.physics_process(self, delta)

func _unhandled_input(event):
	state.handle_input(self, event)

func switch_state(new_state):
	state.exit(self)
	state = states[new_state]
	state.enter(self)
	emit_signal("state_change", new_state)

func _ready():
	$AnimationTree.active = true
	animations = $AnimationTree.get("parameters/playback")

func get_input_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis

func take_damage(attacker):
	print("Attacked by " + attacker.name)
