extends State


@export var max_speed: float = 8.0
@export var acceleration: float = 3.0
@export var minimum_velocity: float = 5.0

func can_enter(_prev_state: String):
	return player.is_on_floor() and player.input_dir != Vector2.ZERO

func enter(_prev_state: String) -> void:
	player.model.get_node("AnimationPlayer").play("basic/run")

func move_player():
	player.stand_up()
	player.head_bob(0.2, 22.0 + acceleration)

	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	var acceleration_normalized = player.velocity.length() / max_speed
	player.model.get_node("AnimationPlayer").speed_scale = acceleration_normalized + 0.3
	super.move_player()

func exit(next_state: String) -> void:
	if next_state == "AirTime":
		player.model.get_node("AnimationPlayer").play("basic/fall")

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch") and player.is_on_floor():
		if player.velocity.length() >= minimum_velocity:
			change_state.emit("Sliding")
		else:
			change_state.emit("Crouching")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		change_state.emit("Jumping")
