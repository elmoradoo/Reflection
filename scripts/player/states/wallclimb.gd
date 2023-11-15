extends BaseState


var climb_is_over: bool = false
var climbing_speed: float = 4.0
var old_vel

func climbing_timer():
	climb_is_over = true
	
func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("wallclimb_time").timeout.connect(climbing_timer)

func get_state_name():
	return enums.player_states.WallClimb

var collided = false
func _on_collision(previous_vel: Vector3, new_collision: KinematicCollision3D):
	super._on_collision(previous_vel, new_collision)
	collided = true
	var vel_length = Vector2(player.velocity.x, player.velocity.z).length()
	var before_collision_vel_length = Vector2(previous_vel.x, previous_vel.z).length()
	player.velocity += player.velocity.normalized() * Vector3(0, 1, 0) * (before_collision_vel_length - vel_length)

func enter():
	player.timers.get_node("wallclimb_time").start()
	old_vel = player.velocity
	#player.animation_player.play("wallclimb")

func exit():
	player.timers.get_node("wallclimb_time").stop()
	climb_is_over = false
	collided = false
	
func update_mouse(event):
	if event is InputEventMouseMotion:
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		player.neck.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.neck.rotation.y = clamp(player.neck.rotation.y, deg_to_rad(-44.5), deg_to_rad(44.5))

func move_player():
	super.reset_head_bob()
	player.velocity.y += climbing_speed * player.timers.get_node("wallclimb_time").time_left * player.delta
	player.velocity.y = clamp(player.velocity.y, 0, 8.0)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_pressed("jump"):
		change_state.emit(enums.player_states.Jumping)

func check_physics_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		change_state.emit(enums.player_states.Sprinting)
	elif player.is_on_floor():
		change_state.emit(enums.player_states.Idle)
	elif super.can_ledge_grab():
		change_state.emit(enums.player_states.LedgeGrab)
	elif super.can_ledgeclimb():
		change_state.emit(enums.player_states.LedgeClimb)
	elif climb_is_over:
		change_state.emit(enums.player_states.AirTime)
