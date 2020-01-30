extends StateMachine

func start():
	states_map = {
		"idle": $Idle,
		"run": $Run,
		"roll": $Roll,
		"attack1": $Attack,
		"attack2": $Attack2,
		"attack3": $Attack3,
		"shield": $Shield
	}
	.start()
