extends Node2D

func _physics_process(delta):
	var pos = get_global_mouse_position()
	var player = get_node("../Player")
	var path = $Navigation2D.get_simple_path(player.global_position, pos)
