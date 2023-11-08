extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")

var old_vel: Vector3 = Vector3.ZERO
func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.WallRun

func enter():
	old_vel = player.velocity
	

func exit():
	player.velocity = old_vel

#Raycast front wall (2 ?)
#If enough upwards velocity in airtime
#Timer for max climb duration

func update():
	super.update_event(player)
	player.velocity.y += 0.1
	
func get_next_state():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		return enums.player_states.Idle
	elif player.velocity.y >= 6 and not player.rc_feets.get_node("front").is_colliding():
		return enums.player_states.AirTime
	return enums.player_states.WallRun
	
