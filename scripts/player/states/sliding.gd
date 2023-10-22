extends Node

var player: playerData
const max_speed: float = 5.0
var crouching_depth: float = -0.5
var lerp_speed = 10.0
var enums = preload("res://scripts/player/enums.gd")
#Unused
const sliding_initial_force: float = 1.2

func init(obj):
	player = obj

func enter():
	player.velocity.x *= sliding_initial_force
	player.velocity.z *= sliding_initial_force

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
	player.velocity.x = move_toward(player.velocity.x, 0, 0.1)
	player.velocity.z = move_toward(player.velocity.z, 0, 0.1)
	
func exit():
	pass

func check():
	if Input.is_action_just_released("crouch"): #or player.velocity.length() <= player.sliding_minimum_velocity:
		player.current_state = enums.player_states.Idle
		
