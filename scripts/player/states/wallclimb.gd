extends BaseState


var climb_is_over: bool = false
var climbing_speed: float = 0.2

func climbing_timer():
	climb_is_over = true
	
func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("wallclimb_time").timeout.connect(climbing_timer)

func get_state_name():
	return enums.player_states.WallClimb

func enter():
	player.timers.get_node("wallclimb_time").start()
	player.velocity.x /= 4
	player.velocity.z /= 4

func exit():
	player.timers.get_node("wallclimb_time").stop()
	climb_is_over = false
	player.velocity = Vector3.ZERO

func move_player():
	super.reset_head_bob()
	player.velocity.y += climbing_speed * player.timers.get_node("wallclimb_time").time_left
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
