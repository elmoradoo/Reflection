extends BaseState


var enums = preload("res://scripts/player/enums.gd")

var old_vel: Vector3 = Vector3.ZERO
var old_rotation_head: Vector3 = Vector3.ZERO

var is_jumping: bool = false

const base_wallrun_speed: float = 0.1

var first_collision_travel: Vector3 = Vector3.ZERO


func get_state_name():
	return enums.player_states.WallRun


func enter():
	old_vel = player.velocity
	player.timers.get_node("wallrun_time").start()

	# Wait for new velocity to change after collision
	var old_total_speed = player.velocity.length()
	var max_move_attempts = 5
	for i in range(max_move_attempts):
		if player.velocity != old_vel:
			break # Collision happened
		player.move_and_slide()

	# Take the velocity lost in the wall and put it back on the player
	player.velocity += player.velocity.normalized() * (old_total_speed - player.velocity.length())

func exit():
	player.velocity = old_vel
	player.velocity.y = 0
	if is_jumping:
		player.velocity = \
			(player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * \
			(wallrun_jumping_velocity + player.timers.get_node("wallrun_time").time_left)
		is_jumping = false
	player.timers.get_node("wallrun_time").stop()


func update():
	pass


func get_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.is_on_floor():
		return enums.player_states.Idle
	elif Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		return enums.player_states.Jumping
	elif super.can_wallrun() or player.is_on_wall_only():
		return enums.player_states.WallRun
	return enums.player_states.AirTime

