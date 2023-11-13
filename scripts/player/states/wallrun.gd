extends BaseState


var old_vel: Vector3 = Vector3.ZERO
var old_rotation_head: Vector3 = Vector3.ZERO

var is_jumping: bool = false


const base_wallrun_y_speed: float = 0.1
const wallrun_jumping_speed: float = 0.2

var wall_normal: Vector3 = Vector3.ZERO

func get_state_name():
	return enums.player_states.WallRun


func _on_collision(previous_vel: Vector3, new_collision: KinematicCollision3D):
	super._on_collision(previous_vel, new_collision)
	# Compute velocity compensation while avoiding y (we are on a wall, so we should not compensate y)
	var vel_length = Vector2(player.velocity.x, player.velocity.z).length()
	var before_collision_vel_length = Vector2(previous_vel.x, previous_vel.z).length()
	player.velocity += player.velocity.normalized() * Vector3(1, 0, 1) * (before_collision_vel_length - vel_length)

	# Make sure it's a wall.
	if new_collision.get_normal().y < 1:
		wall_normal = new_collision.get_normal()
		rotate_player_outside_wall()


func update_mouse(event):
	if event is InputEventMouseMotion:
		# if wall_normal.y is present, then it's simply not a wall!
		if wall_normal and not wall_normal.y:
			var rotation = deg_to_rad(-event.relative.x * player.mouse_sensitivity)
			# Collision with wall happened, we know where the player needs to look at.
			if can_rotate_player_on_wall(rotation):
				player.rotate_y(rotation)
			#else:
				# The rotation is off-limits, push back mouse.
				#player.rotate_y(-rotation)
		else:
			# wall collision has not happened yet
			super.update_mouse(event)


func rotate_player_outside_wall():
	if not can_rotate_player_on_wall(0):
		# This is the angle relative to the rotation (negative angle is left, positive is right)
		var player_angle_z = player.transform.basis.z.signed_angle_to(wall_normal, Vector3.UP)
		var player_angle_x = player.transform.basis.x.signed_angle_to(wall_normal, Vector3.UP)

		# This is the angle between what the player is looking at and the wall
		var angle = abs(player.transform.basis.z.signed_angle_to(wall_normal, player.transform.basis.x))
		print("Angle: " + str(angle))
		print("Angle_Z: " + str(player_angle_z))
		print("Angle_x: " + str(player_angle_x))
		if player_angle_x + player_angle_z > 0:
			player.animation_player.play("wallrun_left")
			player.rotate_y(-(PI/2-angle))
		else:
			player.animation_player.play("wallrun_right")
			player.rotate_y((PI/2-angle))


func can_rotate_player_on_wall(rotation=0):
	# PI/2 (90deg) is the angle paralel to the wall
	var limit_min = PI/2

	# PI (180deg) is the angle normal to the wall
	var limit_max = PI

	# This is the angle between what the player is looking at and the wall
	var angle = player.transform.basis.z.signed_angle_to(wall_normal, player.transform.basis.x)

	angle = angle + abs(rotation)
	return clamp(angle, limit_min, limit_max) == angle


func enter():
	old_vel = player.velocity

	#player.velocity.y += 1
	player.timers.get_node("wallrun_time").start()
	if player.touched_floor:
		is_jumping = false

	if player.get_last_slide_collision():
		# Collision was triggered during AirTime
		wall_normal = player.get_last_slide_collision().get_normal()
		rotate_player_outside_wall()
	# Collision has not happened yet, we need to wait for _on_collision to trigger.

func exit():
	player.velocity = old_vel
	player.velocity.y = 0
	if is_jumping:
		player.velocity = \
			(player.transform.basis * Vector3(player.input_dir.x, 1, player.input_dir.y)).normalized() * \
			(wallrun_jumping_velocity + player.timers.get_node("wallrun_time").time_left)
	player.timers.get_node("wallrun_time").stop()
	wall_normal = Vector3.ZERO

func move_player():
	player.velocity.y += base_wallrun_y_speed * player.timers.get_node("wallrun_time").time_left
	super.move_player()

func get_input_next_state():
	super.get_input_next_state()
	if Input.is_action_just_pressed("jump"):
		if not is_jumping:
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

