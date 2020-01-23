extends KinematicBody2D

onready var states = {
	"idle": $States/Idle,
	"chase": $States/Chase,
	"attack": $States/Attack,
	"stagger": $States/Stagger
}
onready var state = states["idle"]
var prev_state
var target

var velocity : = Vector2.ZERO
var facing : = Vector2.RIGHT
var last_attacker : Object

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
	if state != null:
		state.exit(self)
	prev_state = state
	if new_state is Node:
		state = new_state
	else:
		state = states[new_state]
	state.enter(self)

func to_previous_state():
	if not prev_state:
		switch_state("idle")
	else:
		switch_state(prev_state)


func _on_Hurtbox_hit(attacker):
	last_attacker = attacker
	switch_state("stagger")
