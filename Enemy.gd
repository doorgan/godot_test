extends KinematicBody2D

onready var states = {
	"idle": $States/Idle,
	"chase": $States/Chase
}
onready var state = states["idle"]

var target

func _ready():
	switch_state("idle")

func _physics_process(delta):
	state.physics_process(self, delta)

func switch_state(new_state):
	print("new enemy state: " + new_state)
	if state != null:
		state.exit(self)
	state = states[new_state]
	state.enter(self)