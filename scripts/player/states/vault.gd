extends BaseState

var enums = preload("res://scripts/player/enums.gd")

var player: playerData

func init(obj):
	player = obj

func enter():
	pass

func update():
	super.update_event(player)
	if player.rc_feets.get_node("front").is_colliding():
		player.velocity.y += 0.1
	else:
		var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * 3
		player.velocity = target_velocity

func exit():
	pass

func get_state_name():
	return enums.player_states.Vault

func get_next_state():
	if player.myself.is_on_floor():
		if player.velocity.length() >= 2:
			return enums.player_states.Sprinting
		else:
			return enums.player_states.Idle
	elif not player.rc_feets.get_node("front").is_colliding():
		return enums.player_states.AirTime		
	return enums.player_states.Vault  
