extends Unit

signal died

var target

var velocity : = Vector2.ZERO
var facing : = Vector2.RIGHT setget set_facing
var last_attacker : Object
var staggered : = false
var dead : = false

onready var animations = $AnimationPlayer

func _ready():
	$States.start()
	$Healthbar.value = health

func take_damage(attack):
	health -= attack.damage
	$Healthbar.value = health
	if health <= 0:
		dead = true
		$States._switch_state("die")
	else:
		stagger(attack.attacker)

func stagger(attacker):
	last_attacker = attacker
	$States._push_state("stagger")

func remove():
	$States.set_active(false)
	queue_free()

func set_facing(new_dir):
	facing = new_dir
	if facing.x > 0:
		scale.x = scale.y * 1
	if facing.x < 0:
		scale.x = scale.y * -1

func _on_Hurtbox_hit(attacker):
	if dead:
		return
	if attacker.is_in_group("enemy"):
		return
	take_damage(attacker)
