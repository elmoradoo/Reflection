extends BaseState


var enums = preload("res://scripts/player/enums.gd")
var old_vel: Vector3 = Vector3.ZERO

#var is_climbvaulting_over = false
#var is_climbvaulting = false


func get_state_name():
	return enums.player_states.LedgeGrab

func enter():
	player.gravity_enabled = false
	player.velocity = Vector3.ZERO
	#if player.velocity.length() >= 5:
	#	is_climbvaulting = true

func exit():
	player.gravity_enabled = true	
	#is_climbvaulting_over = false	

func move_player():
#	if is_climbvaulting == is_climbvaulting:
#		if player.rc_feets.get_node("front").is_colliding():
#			player.velocity.y += 0.1
#		else:
#			var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * 3
#			player.velocity = target_velocity
#			is_climbvaulting_over = true
#	else:
#		pass
		#player.velocity.y += player.gravity
	super.move_player()

func get_input_next_state():
	super.get_input_next_state()
	if Input.is_action_just_released("crouch"):
		return enums.player_states.AirTime
	elif Input.is_action_pressed("jump"):
		return enums.player_states.LedgeClimb


func get_physics_next_state():
#	if player.is_on_floor():
#		if player.velocity.length() >= 2:
#			return enums.player_states.Sprinting
#		else:
#			return enums.player_states.Idle
##	else:
#	if is_climbvaulting_over:
#		return enums.player_states.AirTime
	return enums.player_states.LedgeGrab
	
