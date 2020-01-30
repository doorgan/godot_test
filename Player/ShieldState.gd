extends State

export(float) var parry_duration = 0.05

func _ready():
	$ParryTimer.connect("timeout", self, "end_parry")

func enter():
	owner.get_node("Shield").show()
	owner.play_animation("shield")
	owner.is_shielding = true
	owner.can_parry = true
	$ParryTimer.wait_time = parry_duration
	$ParryTimer.start()

func end_parry():
	owner.can_parry = false

func exit():
	owner.get_node("Shield").hide()
	owner.is_shielding = false
	$ParryTimer.stop()

func handle_input(event):
	if Input.is_action_just_released("shield"):
		emit_signal("finished", "previous")
