extends BaseState


var move_speed: float = 2.0
var collided = false

func get_state_name():
	return enums.player_states.LedgeGrab

func _on_collision(previous_vel: Vector3, new_collision: KinematicCollision3D):
	super._on_collision(previous_vel, new_collision)
	collided = true
	
	
func enter():
	if player.velocity.y < 0:
		player.velocity.y = 0
	player.velocity = Vector3.ZERO	
	player.gravity_enabled = false
func exit():
	player.gravity_enabled = true
	collided = false

func move_player():
	super.move_player()
	var forward = player.transform.basis.z.normalized()
	if player.input_dir.x == 1:
		player.position.z += -forward.x * player.delta * move_speed
	elif player.input_dir.x == -1:
		player.position.z += forward.x * player.delta * move_speed
	
func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_released("crouch"):
		change_state.emit(enums.player_states.AirTime)
	elif Input.is_action_pressed("jump"):
		change_state.emit(enums.player_states.LedgeClimb)


func check_physics_next_state():
	if player.velocity.y > 2:
		change_state.emit(enums.player_states.LedgeClimb)
	
