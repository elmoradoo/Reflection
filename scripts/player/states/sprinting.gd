extends BaseState


const max_speed: float = 8.0
var acceleration: float = 3.0


func enter():
	player.model.get_node("AnimationPlayer").play("basic/run")

func move_player():
	super.stand_up()
	super.head_bob(0.2, 22.0 + acceleration)

	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	var acceleration_normalized = player.velocity.length() / max_speed
	player.model.get_node("AnimationPlayer").speed_scale = acceleration_normalized + 0.3
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch") and player.is_on_floor():
		if player.velocity.length() >= sliding_minimum_velocity:
			change_state.emit("Sliding")
		else:
			change_state.emit("Crouching")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		change_state.emit("Jumping")

func check_physics_next_state():
	if player.is_on_floor():
		if player.input_dir == Vector2.ZERO:
			change_state.emit("Idle")
	else:
		player.model.get_node("AnimationPlayer").play("basic/fall")
		change_state.emit("AirTime")
