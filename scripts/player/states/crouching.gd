extends Node

var enums = preload("res://scripts/player/enums.gd")
var player
const max_speed: float = 3.0
var crouching_depth: float = -0.5
var lerp_speed = 10.0

func init(obj):
	player = obj

func enter():
	pass


func exit():
	pass


func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

func update():
	update_event()
	player.head.position.y = lerp(player.head.position.y, crouching_depth, lerp_speed * player.delta)
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed
	player.direction = lerp(player.direction, (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized(), lerp_speed * player.delta)

func check():
	if player.myself.is_on_floor():
		if Input.is_action_pressed("crouch"):
			player.current_state = enums.player_states.Crouching
		else:
			player.current_state = enums.player_states.Idle
