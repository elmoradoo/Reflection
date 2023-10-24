extends Node

var player: playerData
const jump_velocity: float = 4.5
var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func enter():
	player.animation_player.play("jump")

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null


func update():
	update_event()
	var forward_velocity = Vector3(player.velocity.x, 0, player.velocity.z)
	print(forward_velocity)

	player.velocity.y += jump_velocity
	#player.velocity.x = forward_velocity.x
#	player.velocity.z = forward_velocity.z
	#var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed

func exit():
	pass

func check():
	if not player.myself.is_on_floor():
		player.current_state = enums.player_states.AirTime
