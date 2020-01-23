extends KinematicBody2D

export (int) var max_health = 5

onready var states = {
	"idle": $States/Idle,
	"chase": $States/Chase,
	"attack": $States/Attack,
	"stagger": $States/Stagger,
	"die": $States/Die
}
onready var state = states["idle"]
var target

var velocity : = Vector2.ZERO
var facing : = Vector2.RIGHT
var last_attacker : Object
var health = max_health
var staggered : = false
var dead : = false

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
	state = states[new_state]
	state.enter(self)

func take_damage(attacker):
	health -= 1
	if health <= 0:
		dead = true
		switch_state("die")
	else:
		last_attacker = attacker
		switch_state("stagger")

func _on_Hurtbox_hit(attacker):
	if dead:
		return
	if attacker.is_in_group("enemy"):
		return
	take_damage(attacker)
