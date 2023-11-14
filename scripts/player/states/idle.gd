extends BaseState


var idle_lerp_speed = 2.0 


func enter():
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func get_state_name():
	return enums.player_states.Idle

func move_player():
	super.stand_up()
	super.reset_neck(2.0)
	super.reset_head_bob()
	player.velocity.x = move_toward(player.velocity.x, 0, idle_lerp_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, idle_lerp_speed)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch"):
		change_state.emit(enums.player_states.Crouching)
	elif Input.is_action_pressed("jump"):
		change_state.emit(enums.player_states.Jumping)

func check_physics_next_state():
	if player.input_dir != Vector2.ZERO:
		change_state.emit(enums.player_states.Sprinting)
