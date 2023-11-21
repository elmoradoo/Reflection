extends BaseState

func enter():
	player.coiling_collision_shape.disabled = false
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true

func exit():
	player.coiling_collision_shape.disabled = true
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = false

func get_state_name():
	return enums.player_states.Coiling

func move_player():
	super.move_player()

func check_input_next_state():
	pass

func check_physics_next_state():
	if player.is_on_floor():
		change_state.emit(enums.player_states.Idle)
