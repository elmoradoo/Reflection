extends BaseState


var old_vel: Vector3 = Vector3.ZERO
var done: bool = false
var ledgeclimb_speed: float = 2.0

func get_state_name():
	return enums.player_states.LedgeClimb

func enter():
	old_vel = player.velocity
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = false

func exit():
	done = false

func move_player():
	if not done:
		player.velocity.y += ledgeclimb_speed
	if player.velocity.y >= 6.0:
		done = true
		player.coiling_collision_shape.disabled = true
		player.standing_collision_shape.disabled = false
		player.crouching_collision_shape.disabled = false
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * ledgeclimb_speed
	player.velocity.x = target_velocity.x
	player.velocity.z = target_velocity.z
	super.move_player()

func get_physics_next_state():
	if player.is_on_floor():
		return enums.player_states.Idle
	return enums.player_states.LedgeClimb
