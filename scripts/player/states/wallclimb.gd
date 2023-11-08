extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")
var old_vel: Vector3 = Vector3.ZERO

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.WallClimb

func enter():
	old_vel = player.velocity
	player.timers.get_node("wallclimb_time").start()
	

func exit():
	player.velocity = old_vel
	player.timers.get_node("wallclimb_time").stop()	

#Raycast front wall (2 ?)
#If enough upwards velocity in airtime
#Timer for max climb duration

func update():
	super.update_event(player)
	#print(player.timers.get_node("wallclimb_time").get_time_left())

#	if player.timers.get_node("wallclimb_time").is_stopped():
#		print("over")
	player.velocity.y += 0.3
	
func get_next_state():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		return enums.player_states.Idle
	elif player.rc_feets.get_node("front").is_colliding() and not player.rc_head.get_node("front").is_colliding():
		return enums.player_states.LedgeGrab
	elif player.velocity.y >= 6 and not player.rc_feets.get_node("front").is_colliding():
		return enums.player_states.AirTime
	else:
		return enums.player_states.WallClimb
	
