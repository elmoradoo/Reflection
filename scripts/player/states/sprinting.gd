extends Node

var player: playerData
const max_speed: float = 8.0
var lerp_speed: float = 0.5

var head_bobbing_vector: Vector2 = Vector2.ZERO
var head_bobbing_index: float = 0.0
var head_bobbing_intensity: float = 0.2
var head_bobbing_speed: float = 22.0
var head_bobbing_lerp: float = 10.0

var stand_up_lp = 10.0

var acceleration = 5.0

var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func enter():
	pass

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

func update():
	update_event()
	
	#Stand up
	player.neck.rotation.y = lerp(player.neck.rotation.y, 0.0, player.delta * stand_up_lp)
	player.head.position.y = lerp(player.head.position.y, 0.0, stand_up_lp * player.delta)
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true
	
	
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	#Head bobbing
	head_bobbing_index += head_bobbing_speed * player.delta
	head_bobbing_vector.y = sin(head_bobbing_index)
	head_bobbing_vector.x = sin(head_bobbing_index / 2) + 0.5
	
	player.eyes.position.y = lerp(player.eyes.position.y, head_bobbing_vector.y * (head_bobbing_intensity / 2.0), player.delta * head_bobbing_lerp)
	player.eyes.position.x = lerp(player.eyes.position.x, head_bobbing_vector.x * head_bobbing_intensity, player.delta * head_bobbing_lerp)
	
func exit():
	player.eyes.position.y = 0# TODO lerp it somehow
	player.eyes.position.x = 0#lerp(player.eyes.position.x, head_bobbing_vector.x * head_bobbing_intensity, player.delta * lerp_speed)

func check():
	if player.myself.is_on_floor():
		if Input.is_action_pressed("crouch") and player.velocity.length() >= player.sliding_minimum_velocity:
			player.current_state = enums.player_states.Sliding
		elif Input.is_action_pressed("crouch"):
			player.current_state = enums.player_states.Crouching
		elif player.input_dir == Vector2.ZERO:
			player.current_state = enums.player_states.Idle
		if Input.is_action_just_pressed("jump"):
			player.current_state = enums.player_states.Jumping
	else:
		player.current_state = enums.player_states.AirTime
		
