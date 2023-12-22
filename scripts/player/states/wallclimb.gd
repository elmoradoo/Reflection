extends State


#Climbing vars
@export_group("Climbing")
@export var climbing_speed: float = 4.0
@export var climbable_min_velocity: float = 2.0
@export var climb_time_limit: float = 0.7


#Rotation vars
@export_group("Rotation")
@export var forward_velocity: float = 5.0
@export var rotation_time_limit: float = 0.7

var pressed_rotate = false

var exit_velocity: Vector3 = Vector3.ZERO

#Timers
var wallclimb_time: Timer
var wallclimb_jump_time: Timer


func init(player_obj: Player):
	super.init(player_obj)
	wallclimb_time = Timer.new()
	wallclimb_time.one_shot = true
	add_child(wallclimb_time)
	
	wallclimb_jump_time = Timer.new()
	wallclimb_jump_time.one_shot = true
	add_child(wallclimb_jump_time)

func can_enter(_prev_state: String) -> bool:
	if not player.get_last_slide_collision():
		return false
	if not player.rc_torso.get_node("front").is_colliding() or player.velocity.y < climbable_min_velocity:
		return false
	var col = player.rc_torso.get_node("front").get_collision_normal()
	var ray_direction = player.rc_torso.get_node("front").global_transform.basis.z.normalized()
	var dot_product = abs(col.dot(ray_direction))
	if dot_product < 0.8:
		return false
	else:
		return true

func enter(_prev_state: String) -> void:
	wallclimb_time.start(climb_time_limit)

	exit_velocity = Vector3.ZERO
	player.velocity.y = 6.0 if player.velocity.y < 6.0 else player.velocity.y
	player.velocity.x = 0
	player.velocity.z = 0

func exit(_next_state: String) -> void:
	wallclimb_time.stop()
	wallclimb_jump_time.stop()
	pressed_rotate = false
	player.velocity = exit_velocity
	player.is_rotating = false

func update_mouse(event):
	if pressed_rotate:
		super.update_mouse(event)
	elif event is InputEventMouseMotion:
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		player.neck.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.neck.rotation.y = clamp(player.neck.rotation.y, deg_to_rad(-44.5), deg_to_rad(44.5))

func move_player():
	player.reset_head_bob()
	player.velocity.y += climbing_speed * wallclimb_time.time_left * player.delta
	player.velocity.y = clamp(player.velocity.y, 0, 8.0)
	player.reset_neck(5.0)
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
	if Input.is_action_just_pressed("jump") and pressed_rotate:
		wall_jump()

	if Input.is_action_just_pressed("rotate") and not pressed_rotate:
		pressed_rotate = true
		wallclimb_jump_time.start(rotation_time_limit)
		player.smooth_rotate(PI)

func check_physics_next_state():
	super.check_physics_next_state()
	if pressed_rotate:
		if wallclimb_jump_time.is_stopped():
			change_state.emit("AirTime")
	elif wallclimb_time.is_stopped():
		change_state.emit("AirTime")
