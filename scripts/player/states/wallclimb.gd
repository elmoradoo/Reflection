extends State


#Climbing vars
@export_group("Climbing")
@export var climbing_speed: float = 4.0
@export var climbable_min_velocity: float = 2.0


#Rotation vars
@export_group("Rotation")
@export var forward_velocity: float = 5.0
@export var rotation_speed: float = 15.0
var player_pressed_rotate = false
var is_rotating = false
var has_rotated = false

var rotation_y_when_pressing_rotate: float
var target_rotation: float

var exit_velocity: Vector3 = Vector3.ZERO

#Timers
var climb_is_over: bool = false
var rotate_air_time_is_over: bool = false
func climbing_timer(): climb_is_over = true
func wallclimb_jump_timer(): rotate_air_time_is_over = true

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("wallclimb_time").timeout.connect(climbing_timer)
	player.timers.get_node("wallclimb_jump_time").timeout.connect(wallclimb_jump_timer)

func can_enter() -> bool:
	if not player.rc_torso.get_node("front").is_colliding() or player.velocity.y < climbable_min_velocity:
		return false
	var col = player.rc_torso.get_node("front").get_collision_normal()
	var ray_direction = player.rc_torso.get_node("front").global_transform.basis.z.normalized()
	var dot_product = abs(col.dot(ray_direction))
	if dot_product < 0.8:
		return false
	else:
		return true

func enter():
	player.timers.get_node("wallclimb_time").start()
	exit_velocity = Vector3.ZERO
	player.velocity.y = 6.0 if player.velocity.y < 6.0 else player.velocity.y
	player.velocity.x = 0
	player.velocity.z = 0

func exit():
	#Stopping timers
	player.timers.get_node("wallclimb_time").stop()
	player.timers.get_node("wallclimb_jump_time").stop()
	#Reseting climbing vars
	climb_is_over = false
	#Reseting rotation vars
	player_pressed_rotate = false
	is_rotating = false	
	has_rotated = false
	rotate_air_time_is_over = false
	target_rotation = 0.0
	player.velocity = exit_velocity

func rotate_player():
	if not player_pressed_rotate:
		return
	player.rotation.y = lerp(player.rotation.y, target_rotation, rotation_speed * player.delta)
	player.rotation.y = fmod(player.rotation.y, TAU)
	var tolerance = 0.01
	if abs(player.rotation.y - target_rotation) < tolerance:
		player.rotation.y = target_rotation
		is_rotating = false
		has_rotated = true
		player.timers.get_node("wallclimb_jump_time").start()

func update_mouse(event):
	if is_rotating:
		return
	elif event is InputEventMouseMotion:
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		player.neck.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.neck.rotation.y = clamp(player.neck.rotation.y, deg_to_rad(-44.5), deg_to_rad(44.5))

func move_player():
	player.reset_head_bob()
	if is_rotating:
		rotate_player()
	player.velocity.y += climbing_speed * player.timers.get_node("wallclimb_time").time_left * player.delta
	player.velocity.y = clamp(player.velocity.y, 0, 8.0)
	super.move_player()

func wall_jump():
	var forward = player.transform.basis.z.normalized()
	player.velocity.y = 0.0
	player.velocity.x += -forward.x * forward_velocity
	player.velocity.z += -forward.z * forward_velocity
	exit_velocity = player.velocity
	change_state.emit("Jumping")

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_pressed("jump") and has_rotated:
		wall_jump()
	if Input.is_action_just_pressed("rotate") and player_pressed_rotate == false:
		player_pressed_rotate = true
		is_rotating = true
		rotation_y_when_pressing_rotate = player.rotation.y
		target_rotation = rotation_y_when_pressing_rotate + deg_to_rad(180)
		target_rotation = fmod(target_rotation + PI, TAU) - PI

func check_physics_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		change_state.emit("Sprinting")
	elif player.is_on_floor():
		change_state.emit("Idle")
	elif can_change_to("LedgeGrab"):
		change_state.emit("LedgeGrab")
	elif can_change_to("LedgeClimb"):
		change_state.emit("LedgeClimb")
	elif player_pressed_rotate:
		if rotate_air_time_is_over:
			change_state.emit("AirTime")
	elif climb_is_over:
		change_state.emit("AirTime")
