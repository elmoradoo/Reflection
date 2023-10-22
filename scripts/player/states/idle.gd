extends Node

var enums = preload("res://scripts/player/enums.gd")

var player: playerData
var lerp_speed = 2.0

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
	player.neck.rotation.y = lerp(player.neck.rotation.y, 0.0, player.delta * lerp_speed) # ICI 0.0
	player.head.position.y = lerp(player.head.position.y, 0.0, lerp_speed * player.delta)
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true
	player.velocity.x = move_toward(player.velocity.x, 0, lerp_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, lerp_speed)
	player.current_speed = player.velocity.length()

func check():
	#var player.input_dir = Input.get_vector("left", "right", "forward", "backward")
	if player.myself.is_on_floor():
		if Input.is_action_just_pressed("crouch"):
			player.current_state = enums.player_states.Crouching
		elif Input.is_action_just_released("crouch") and not player.raycasts.get_node("top_of_head").is_colliding():
			player.current_state = enums.player_states.Idle
		elif Input.is_action_pressed("sprint") and player.input_dir != Vector2.ZERO:
			player.current_state = enums.player_states.Sprinting
		elif player.input_dir != Vector2.ZERO:
			player.current_state = enums.player_states.Walking
		if Input.is_action_just_pressed("jump"):
			player.current_state = enums.player_states.Jumping
