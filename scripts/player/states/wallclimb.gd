extends BaseState

var old_vel: Vector3 = Vector3.ZERO
var climb_is_over: bool = false
var climbing_speed: float = 0.2

func climbing_timer():
	climb_is_over = true
	
func init(obj):
	super.init(obj)
	player.timers.get_node("wallclimb_time").timeout.connect(climbing_timer)

func get_state_name():
	return enums.player_states.WallClimb

func enter():
	old_vel = player.velocity
	player.timers.get_node("wallclimb_time").start()
	player.velocity.x /= 4
	player.velocity.z /= 4

func exit():
	player.timers.get_node("wallclimb_time").stop()
	climb_is_over = false

func move_player():
	super.reset_head_bob()
	player.velocity.y += climbing_speed * player.timers.get_node("wallclimb_time").time_left
	super.move_player()

func get_physics_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.is_on_floor():
		return enums.player_states.Idle
	elif super.can_ledge_grab():
		return enums.player_states.LedgeGrab
	elif super.can_ledgeclimb():
		return enums.player_states.LedgeClimb
	elif climb_is_over or not super.can_wallclimb():
		return enums.player_states.AirTime
	else:
		return enums.player_states.WallClimb
