extends Unit

signal state_change(new_state)

var MAX_SPEED: float = 30
var ACCELERATION: float = 200
var motion: Vector2 = Vector2()
var facing: Vector2 = Vector2.RIGHT setget set_facing
var animations

# Flags
var is_shielding : = false
var can_parry : = false

func _unhandled_input(event):
	if Input.is_action_just_released("invulnerable"):
		print("toggle inv")
		if has_effect(EffectInvulnerable):
			remove_effect(EffectInvulnerable)
		else:
			add_effect(EffectInvulnerable)

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


func _on_hit(attacker):
	if is_shielding and is_shield_facing(attacker.global_position):
		print("blocked!")
		return
	take_damage(attacker)

func is_shield_facing(hit_position : Vector2) -> bool:
	var shield_direction = sign(facing.x)
	var hit_direction = sign(global_position.x - hit_position.x)
	return shield_direction != hit_direction
