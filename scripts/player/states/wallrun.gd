extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")

var old_vel: Vector3 = Vector3.ZERO
var is_jumping: bool = false

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.WallRun

func enter():
	old_vel = player.velocity
	player.timers.get_node("wallrun_time").start()


func exit():
	player.velocity = old_vel
	player.velocity.y = 0
	if is_jumping:
		player.velocity = \
			(player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * \
			(wallrun_jumping_velocity + player.timers.get_node("wallrun_time").time_left)
		is_jumping = false
	player.timers.get_node("wallrun_time").stop()
#Raycast front wall (2 ?)
#If enough upwards velocity in airtime
#Timer for max climb duration

func update():
	super.update_event(player)
	player.velocity.y += 0.1 * player.timers.get_node("wallrun_time").time_left
	
func get_next_state():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		return enums.player_states.Idle
	elif Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		return enums.player_states.Jumping
	elif super.can_wallrun(player):
		return enums.player_states.WallRun
	#elif not player.myself.is_on_floor():
	#	return enums.player_states.AirTime
	return enums.player_states.WallRun
	
