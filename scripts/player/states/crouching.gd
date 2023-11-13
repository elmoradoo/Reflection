extends BaseState


const max_speed: float = 3.0
var crouch_released: bool = false

func enter():
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	crouch_released = false

func exit():
	pass

func get_state_name():
	return enums.player_states.Crouching

func move_player():
	super.stand_down()
	if player.input_dir != Vector2.ZERO:
		super.head_bob(0.1, 22.0)
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed
	player.direction = lerp(player.direction, (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized(), lerp_speed * player.delta)
	super.move_player()

func get_input_next_state():
	super.get_input_next_state()
	if Input.is_action_pressed("crouch"):
		crouch_released = false
		return enums.player_states.Crouching
	elif not Input.is_action_pressed("crouch"):
		crouch_released = true
		if player.raycasts.get_node("top_of_head").is_colliding():
			return enums.player_states.Crouching
		else:
			return enums.player_states.Idle

func get_physics_next_state():
	if not crouch_released or player.raycasts.get_node("top_of_head").is_colliding():
		return enums.player_states.Crouching
	else:
		return enums.player_states.Idle
