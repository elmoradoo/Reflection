extends State


@export var base_y_speed: float = 0.1
@export var lerp_speed: float = 5.0

@export_group("Jumping")
@export var jumping_speed: float = 0.2
@export var jumping_velocity: float = 7.0


var wall_normal: Vector3 = Vector3.ZERO
var old_vel: Vector3 = Vector3.ZERO
var is_jumping: bool = false

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
		if wall_normal:
			var rotation = deg_to_rad(-event.relative.x * player.mouse_sensitivity)
			# Collision with wall happened, we know where the player needs to look at.
			if can_rotate_player_on_wall(rotation):
				player.rotate_y(rotation)
			else:
				# The rotation is off-limits
				player.neck.rotate_y(rotation)
		else:
			# wall collision has not happened yet
			super.update_mouse(event)


func rotate_player_outside_wall():
	if not can_rotate_player_on_wall(0):
		# This is the angle relative to the rotation (negative angle is left, positive is right)
		var player_angle = player.transform.basis.z.signed_angle_to(wall_normal, Vector3.UP)

		# This is the angle between what the player is looking at and the wall
		var angle = abs(player.transform.basis.z.signed_angle_to(wall_normal, player.transform.basis.x))
		if player_angle < 0:
			player.animation_player.play("wallrun_left")
			player.rotate_y(PI/2-angle)
			player.neck.rotate_y(-(PI/2-angle))
		else:
			player.animation_player.play("wallrun_right")
			player.rotate_y(-(PI/2-angle))
			player.neck.rotate_y(PI/2-angle)


func can_rotate_player_on_wall(rotation=0):
	# PI/2 (90deg) is the angle paralel to the wall
	var limit_min = PI/2

	# PI (180deg) is the angle normal to the wall
	var limit_max = PI

	# This is the angle between what the player is looking at and the wall
	var angle = abs(player.transform.basis.z.signed_angle_to(wall_normal, player.transform.basis.x))
	angle = angle + abs(rotation)
	return clamp(angle, limit_min, limit_max) == angle

func can_enter(_prev_state: String) -> bool:
	if not player.get_last_slide_collision():
		return false
	if not player.rc_torso.get_node("front").is_colliding():
		return false
	var col = player.rc_torso.get_node("front").get_collision_normal()
	var ray_direction = player.rc_torso.get_node("front").global_transform.basis.z.normalized()
	var dot_product = abs(col.dot(ray_direction))
	if dot_product < 0.8:
		return true
	else:
		return false

func enter(_previous_state: String) -> void:
	old_vel = player.velocity

	#player.velocity.y += 1
	player.timers.get_node("wallrun_time").start()
	if player.touched_floor:
		is_jumping = false

	var last_collision = player.get_last_slide_collision()
	if last_collision and last_collision.get_normal().y < 1:
		# Collision was triggered during AirTime
		wall_normal = player.get_last_slide_collision().get_normal()
		rotate_player_outside_wall()
	# Collision has not happened yet, we need to wait for _on_collision to trigger.

func exit(next_state: String) -> void:
	player.velocity = old_vel
	if next_state == "Jumping":
		player.velocity = \
			(player.transform.basis * Vector3(player.input_dir.x, 1, player.input_dir.y)).normalized() * \
			(jumping_velocity + player.timers.get_node("wallrun_time").time_left)
	player.timers.get_node("wallrun_time").stop()
	wall_normal = Vector3.ZERO
	player.velocity.y = 0.0

func move_player():
	player.velocity.y += base_y_speed * player.timers.get_node("wallrun_time").time_left
	player.reset_neck(lerp_speed)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if can_change_to("Jumping"):
		change_state.emit("Jumping")

func check_physics_next_state():
	if not (can_change_to("WallRun") or player.is_on_wall_only()):
		change_state.emit("AirTime")
