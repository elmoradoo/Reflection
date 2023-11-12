extends BaseState


var old_vel: Vector3 = Vector3.ZERO
var old_rotation_head: Vector3 = Vector3.ZERO

var is_jumping: bool = false

const base_wallrun_y_speed: float = 0.1
const wallrun_jumping_speed: float = 0.2


func get_state_name():
	return enums.player_states.WallRun


func _on_collision(previous_vel, collider_id):
	# Compute velocity compensation while avoiding y (we are on a wall, so we should not compensate y)
	var vel_length = Vector2(player.velocity.x, player.velocity.z).length()
	var before_collision_vel_length = Vector2(previous_vel.x, previous_vel.z).length()
	player.velocity += player.velocity.normalized() * Vector3(1, 0, 1) * (before_collision_vel_length - vel_length)

	# If we are on a new wall, or touched the ground, allow jumping again
	if collider_id != player.new_collider_id or player.is_on_floor():
		is_jumping = false


func enter():
	old_vel = player.velocity
	#player.velocity.y += 1
	player.timers.get_node("wallrun_time").start()


func exit():
	player.velocity = old_vel
	player.velocity.y = 0
	if is_jumping:
		player.velocity = \
			(player.transform.basis * Vector3(player.input_dir.x, 1, player.input_dir.y)).normalized() * \
			(wallrun_jumping_velocity + player.timers.get_node("wallrun_time").time_left)
	player.timers.get_node("wallrun_time").stop()


func move_player():
	player.velocity.y += base_wallrun_y_speed * player.timers.get_node("wallrun_time").time_left
	super.move_player()

func get_input_next_state():
	super.get_input_next_state()
	if Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		return enums.player_states.Jumping

func get_physics_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.is_on_floor():
		return enums.player_states.Idle
	elif super.can_wallrun() or player.is_on_wall_only():
		return enums.player_states.WallRun
	return enums.player_states.AirTime

