extends StateMachine

func start():
	states_map = {
		"idle": $Idle,
		"chase": $Chase,
		"attack": $Attack,
		"stagger": $Stagger,
		"die": $Die
	}
	.start()

func _push_state(state_name):
	if not _active:
		return
	if state_name in ["stagger"] and current_state == $Stagger:
		_switch_state(state_name)
	else:
		._push_state(state_name)