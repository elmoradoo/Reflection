extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")
var old_vel: Vector3 = Vector3.ZERO

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.LedgeGrab

func enter():
	pass

func exit():
	pass

func update():
	super.update_event(player)
	
func get_next_state():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		return enums.player_states.Idle
	elif player.velocity.y >= 6 and not player.rc_feets.get_node("front").is_colliding():
		return enums.player_states.AirTime
	else:
		return enums.player_states.LedgeGrab
	
