extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")
var old_vel: Vector3 = Vector3.ZERO
var done: bool = false
func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.LedgeClimb

func enter():
	old_vel = player.velocity
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = false

func exit():
	done = false
	player.coiling_collision_shape.disabled = true
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = false

func update():
	super.update_event(player)
	#player.myself.position.y += 0.1
	#player.myself.position.x -= 0.1
	if not done:
		player.velocity.y += 2.0
	if player.velocity.y >= 6.0:
		done = true
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * 2.0
	player.velocity.x = target_velocity.x
	player.velocity.z = target_velocity.z
	
##	if not player.rc_torso.get_node("front").is_colliding() or not player.rc_feets.get_node("front").is_colliding():
#	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)) * 2
#	#print(target_velocity.z)
#	player.velocity = target_velocity


func get_next_state():
	if player.myself.is_on_floor():
		return enums.player_states.Idle
	#if not player.rc_feets.get_node("front").is_colliding():
	#	return enums.player_states.AirTime
	return enums.player_states.LedgeClimb
