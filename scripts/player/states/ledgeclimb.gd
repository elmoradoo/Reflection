extends State

#Move up
@export_group("Up")
var initial_height: float
@export var up_goal: float = 1.7
@export var up_speed: float = 3.0

#Push forwards
@export_group("Forward")
var push_player: bool = false
@export var forward_goal: float = 1.0
@export var forward_speed: float = 2.0

#Finalize
@export_group("Finalize")
var finalize_player: bool = false
@export var finalize_goal: float = 1.0
@export var finalize_speed: float = 1.0

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("ledgeclimb_time").timeout.connect(ledgeclimb_timer)

func ledgeclimb_timer():
	finalize_player = true
	player.gravity_enabled = true
	player.coiling_collision_shape.disabled = false
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func can_enter() -> bool:
	if (player.rc_torso.get_node("front").is_colliding() 
		and not player.rc_head.get_node("front").is_colliding()):
			return true
	return false

func enter():
	player.crouching_collision_shape.disabled = false
	player.standing_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = true
	player.gravity_enabled = false
	initial_height = player.position.y

func exit():
	player.gravity_enabled = true
	finalize_player = false
	push_player = false
	player.timers.get_node("ledgeclimb_time").stop()

func move_up():
	player.crouching_collision_shape.disabled = true
	if player.position.y - initial_height >= up_goal:
		push_player = true
		player.timers.get_node("ledgeclimb_time").start()
	player.position.y = lerp(player.position.y, player.position.y + up_goal, up_speed * player.delta)

func move_forward():
	var forward_direction = player.global_transform.basis.z
	player.position.x = lerp(player.position.x, player.position.x + forward_goal , -forward_direction.x * forward_speed * player.delta)
	player.position.y = lerp(player.position.y, player.position.y + forward_goal, -forward_direction.y * forward_speed * player.delta)
	player.position.z = lerp(player.position.z, player.position.z + forward_goal, -forward_direction.z * forward_speed * player.delta)

func finalize():
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = true
	player.position.y = lerp(player.position.y, player.position.y - finalize_goal, finalize_speed * player.delta)

func move_player():
	if not finalize_player and push_player:
		player.stand_down()
	if not push_player:
		move_up()
	if push_player and not finalize_player:
		move_forward()
	if finalize_player:
		finalize()
	super.move_player()

func check_input_next_state():
	if player.is_on_floor() and Input.is_action_pressed("forward"):
		change_state.emit("Sprinting")

func check_physics_next_state():
	if player.is_on_floor():
		change_state.emit("Idle")
