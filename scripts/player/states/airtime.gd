extends BaseState


var velocity_before_landing: Vector3
const roll_min_velocity = -8


func get_state_name():
	return enums.player_states.AirTime

func enter():
	velocity_before_landing = player.velocity

func exit():
	player.animation_player.play("land")

func move_player():
	super.reset_head_bob()
	velocity_before_landing = player.velocity
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch") and player.is_on_floor() and velocity_before_landing.y <= roll_min_velocity:
		change_state.emit(enums.player_states.Rolling)

func check_physics_next_state():
	if player.is_on_floor() and velocity_before_landing.y < -5:
		var forward = player.transform.basis.z.normalized()
		player.position.x = lerp(player.position.x, player.position.x + (-forward.x * 4.0), 2.0 * player.delta)
		player.position.z = lerp(player.position.z, player.position.z + (-forward.z * 4.0), 2.0 * player.delta)
		change_state.emit(enums.player_states.Sprinting)
	elif player.is_on_floor():
		change_state.emit(enums.player_states.Idle)
	elif super.can_ledge_grab():
		change_state.emit(enums.player_states.LedgeGrab)
	elif super.can_ledgeclimb():
		change_state.emit(enums.player_states.LedgeClimb)
	elif super.can_vault():
		change_state.emit(enums.player_states.Vault)
	elif super.can_wallclimb():
		change_state.emit(enums.player_states.WallClimb)
	elif super.can_wallrun():
		change_state.emit(enums.player_states.WallRun)
