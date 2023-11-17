extends BaseState

var old_vel: Vector3 = Vector3.ZERO
var push_player = false
var finalize_player: bool = false
var upward_speed: float = 2.0
var initial_height: float
var ledgeclimb_speed = 2.0
var collided = false

func get_state_name():
	return enums.player_states.LedgeClimb

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("ledgeclimb_time").timeout.connect(ledgeclimb_timer)

func ledgeclimb_timer():
	finalize_player = true
	player.gravity_enabled = true
	player.coiling_collision_shape.disabled = false
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func enter():
	old_vel = player.velocity
	player.crouching_collision_shape.disabled = false
	player.standing_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = true
	finalize_player = false
	var forward_direction = player.global_transform.basis.z
	player.velocity = -forward_direction * 4.0 * player.delta
	if player.velocity.y < 0:
		player.velocity.y = 0
		
	#TMP
	player.velocity = Vector3.ZERO
	collided = true
	player.gravity_enabled = false
	initial_height = player.position.y
func exit():
	player.gravity_enabled = true
	finalize_player = false
	push_player = false
	collided = false
	player.timers.get_node("ledgeclimb_time").stop()

func move_up():
	player.crouching_collision_shape.disabled = true
	if player.position.y - initial_height >= 1.7 and not push_player:
		push_player = true
		player.timers.get_node("ledgeclimb_time").start()
	player.position.y = lerp(player.position.y, player.position.y + 1.7, 3.0 * player.delta)

func move_forward():
	var forward_direction = player.global_transform.basis.z
	player.position.x = lerp(player.position.x, player.position.x + 1.0 , -forward_direction.x * ledgeclimb_speed * player.delta)
	player.position.y = lerp(player.position.y, player.position.y + 1.0, -forward_direction.y * ledgeclimb_speed * player.delta)
	player.position.z = lerp(player.position.z, player.position.z + 1.0, -forward_direction.z * ledgeclimb_speed * player.delta)

func finalize():
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = true
	player.position.y = lerp(player.position.y, player.position.y - 1.7, 1.0 * player.delta)

func move_player():
	if not finalize_player and push_player:
		super.stand_down()
	if not push_player:
		move_up()
	if push_player and not finalize_player:
		move_forward()
	if finalize_player:
		finalize()
	super.move_player()

func check_physics_next_state():
	if player.is_on_floor():
		change_state.emit(enums.player_states.Idle)
