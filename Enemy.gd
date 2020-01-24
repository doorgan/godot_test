extends KinematicBody2D

signal died

export (int) var max_health = 5

var target

var velocity : = Vector2.ZERO
var facing : = Vector2.RIGHT setget set_facing
var last_attacker : Object
var health = max_health
var staggered : = false
var dead : = false

onready var animations = $AnimationPlayer

func _ready():
	$States.start()

func take_damage(attacker):
	health -= 1
	if health <= 0:
		dead = true
		$States._switch_state("die")
	else:
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
