extends KinematicBody2D

var knockback_direction = Vector2.ZERO
var motion = Vector2.ZERO

export (int) var hitpoints = 3
export (int) var knockback_speed = 40

func _ready():
	update_hitpoints()

func _on_Hurtbox_hit(attacker):
	hitpoints -= 1
	update_hitpoints()
	var angle = get_angle_to(attacker.position) + PI
	knockback_direction = Vector2(cos(angle), sin(angle))
	knockback()

func _physics_process(delta):
	if(!$Knockback.is_stopped()):
		apply_knockback(delta)

func knockback():
	$Knockback.start()

func apply_knockback(delta):
	motion = knockback_direction * knockback_speed
	motion = move_and_slide(motion)

func update_hitpoints():
	$Label.text = str(hitpoints)
	if(hitpoints <= 0):
		queue_free()

func _on_Knockback_timeout():
	motion = Vector2.ZERO
