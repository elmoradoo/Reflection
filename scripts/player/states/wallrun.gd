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
	player.velocity.y += 1


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
	player.velocity += player.velocity.normalized() * base_wallrun_speed * player.timers.get_node("wallrun_time").time_left


func get_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.is_on_floor():
		return enums.player_states.Idle
	elif Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		return enums.player_states.Jumping
	elif player.is_on_wall_only():
		return enums.player_states.WallRun
	return enums.player_states.AirTime
	
