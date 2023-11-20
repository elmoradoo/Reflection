extends BaseState


const sliding_initial_force: float = 1.2
const min_sliding_speed: float = 4


func get_state_name():
	return enums.player_states.Sliding

func enter():
	player.model.get_node("AnimationPlayer").play("basic/sliding")
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x *= sliding_initial_force
	player.velocity.z *= sliding_initial_force

func move_player():
	super.stand_down()
	player.velocity.x = lerp(player.velocity.x, 0.0, player.delta * 1)
	player.velocity.z = lerp(player.velocity.z, 0.0, player.delta * 1)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_released("crouch"):
		if not player.raycasts.get_node("top_of_head").is_colliding():
			change_state.emit(enums.player_states.Idle)
		else:
			change_state.emit(enums.player_states.Crouching)

func check_physics_next_state():
	if player.velocity.length() < min_sliding_speed:
		change_state.emit(enums.player_states.Crouching)
