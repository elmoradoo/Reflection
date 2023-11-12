extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")
var old_vel: Vector3 = Vector3.ZERO

var climb_is_over = false

func climbing_timer():
	climb_is_over = true
	
func init(obj):
	player = obj
	player.timers.get_node("wallclimb_time").timeout.connect(climbing_timer)

func get_state_name():
	return enums.player_states.WallClimb

func enter():
	old_vel = player.velocity
	player.timers.get_node("wallclimb_time").start()
	player.velocity.x /= 4
	player.velocity.z /= 4

func exit():
	#player.velocity = old_vel 
	player.timers.get_node("wallclimb_time").stop()
	climb_is_over = false

func update():
	super.update_event(player)
	super.reset_head_bob(player)
	player.velocity.y += 0.2 * player.timers.get_node("wallclimb_time").time_left
	
func get_next_state():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		return enums.player_states.Idle
	elif super.can_ledge_grab(player):
		return enums.player_states.LedgeGrab
	elif super.can_ledgeclimb(player):
		return enums.player_states.LedgeClimb
	elif player.timers.get_node("wallclimb_time").time_left == 0:
	elif super.can_vault(player):
		return enums.player_states.Vault
	elif climb_is_over or not super.can_wallclimb(player):
		return enums.player_states.AirTime
	else:
		return enums.player_states.WallClimb
