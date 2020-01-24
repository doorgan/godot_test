extends Node2D
class_name StateMachine

signal state_changed(state_name)

export(NodePath) var INITIAL_STATE

var states_map : = {}
var states_stack : = []
var current_state : State = null

var _active : = false

func _ready():
	for child in get_children():
		child.connect("finished", self, "_switch_state")
	initialize(INITIAL_STATE)

func initialize(start_state):
	set_active(true)
	current_state = states_stack[0]
	current_state.enter()

func _physics_process(delta):
	current_state.physics_process(delta)

func _switch_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	
	if state_name != "previous":
		current_state.enter()

func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null