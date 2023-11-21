extends BaseState


const max_speed: float = 8.0
var acceleration: float = 3.0


func get_state_name():
	return enums.player_states.Sprinting

func enter():
	player.model.get_node("AnimationPlayer").play("basic/run")

func move_player():
	super.stand_up()
	super.head_bob(0.2, 22.0 + acceleration)
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch") and player.is_on_floor():
		if player.velocity.length() >= sliding_minimum_velocity:
			change_state.emit(enums.player_states.Sliding)
		else:
			change_state.emit(enums.player_states.Crouching)
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		change_state.emit(enums.player_states.Jumping)

func check_physics_next_state():
	if player.is_on_floor():
		if player.input_dir == Vector2.ZERO:
			change_state.emit(enums.player_states.Idle)
	else:
		change_state.emit(enums.player_states.AirTime)
