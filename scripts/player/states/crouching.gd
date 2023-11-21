extends BaseState


const max_speed: float = 3.0


func enter():
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false

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

func check_input_next_state():
	super.check_input_next_state()
	if not Input.is_action_pressed("crouch"):
		if not player.raycasts.get_node("top_of_head").is_colliding():
			change_state.emit(enums.player_states.Idle)

	
