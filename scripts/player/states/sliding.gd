extends Node

var player: playerData
const max_speed: float = 5.0
var crouching_depth: float = -0.5
var lerp_speed = 10.0
var enums = preload("res://scripts/player/enums.gd")

const sliding_initial_force: float = 1.2

func init(obj):
	player = obj

func enter():
	player.velocity.x *= sliding_initial_force
	player.velocity.z *= sliding_initial_force

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.neck.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

func update():
	update_event()
	player.head.position.y = lerp(player.head.position.y, crouching_depth, lerp_speed * player.delta)
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x = lerp(player.velocity.x, 0.0, player.delta * 1)
	player.velocity.z = lerp(player.velocity.z, 0.0, player.delta * 1)
	
func exit():
	pass

func check():
	if Input.is_action_just_released("crouch"):
		player.current_state = enums.player_states.Idle
	elif Input.is_action_pressed("crouch") and player.velocity.length() <= 4:
		player.current_state = enums.player_states.Crouching
