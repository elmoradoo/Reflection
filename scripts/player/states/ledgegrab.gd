extends BaseState

var old_vel: Vector3 = Vector3.ZERO
var move_speed: float = 2.0
func get_state_name():
	return enums.player_states.LedgeGrab

func enter():
	player.gravity_enabled = false
	player.velocity = Vector3.ZERO
	
func exit():
	player.gravity_enabled = true	

func move_player():
	super.move_player()
	var forward = player.transform.basis.z.normalized()
	if player.input_dir.x == 1:
		player.position.z += -forward.x * player.delta * move_speed
	elif player.input_dir.x == -1:
		player.position.z += forward.x * player.delta * move_speed
	
func get_input_next_state():
	super.get_input_next_state()
	if Input.is_action_just_released("crouch"):
		return enums.player_states.AirTime
	elif Input.is_action_pressed("jump"):
		return enums.player_states.LedgeClimb


func get_physics_next_state():
	if player.velocity.y > 2:
		return enums.player_states.LedgeClimb
	return enums.player_states.LedgeGrab
	
