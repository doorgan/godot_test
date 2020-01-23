extends KinematicBody2D

onready var states = {
	"idle": $States/Idle,
	"chase": $States/Chase,
	"attack": $States/Attack
}
onready var state = states["idle"]
var target

var velocity : = Vector2.ZERO
var facing : = Vector2.RIGHT

onready var animations = $AnimationPlayer

func _ready():
	switch_state("idle")

func _physics_process(delta):
	state.physics_process(self, delta)
	if facing.x > 0:
		scale.x = scale.y * 1
	if facing.x < 0:
		scale.x = scale.y * -1

func switch_state(new_state):
	print("new enemy state: " + new_state)
	if state != null:
		state.exit(self)
	state = states[new_state]
	state.enter(self)