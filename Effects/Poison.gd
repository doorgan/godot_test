extends Effect
class_name EffectPoison

export (int) var dps : = 5
export (int) var damage_interval : = 1
export (int) var duration : = 5

var timer

func _ready():
	create_timer()
	get_tree().create_timer(duration).connect("timeout", self, "finish")

func create_timer():
	timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = damage_interval
	timer.connect("timeout", self, "apply_poison")
	add_child(timer)
	timer.start()

func apply_poison():
	owner.take_damage({"damage": dps, "attacker": owner})
