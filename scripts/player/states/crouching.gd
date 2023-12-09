extends State

@export var max_speed: float = 3.0
@export var min_sliding_speed: float = 4

func can_enter(_prev_state: String):
	return player.is_on_floor() and Input.is_action_pressed("crouch") and player.velocity.length() < min_sliding_speed

func enter(_prev_state: String) -> void:
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false

func move_player():
	player.stand_down()
	if player.input_dir != Vector2.ZERO:
		player.head_bob(0.1, 22.0)
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed
	player.direction = lerp(player.direction, (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized(), 10.0 * player.delta)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if not Input.is_action_pressed("crouch"):
		if not player.raycasts.get_node("top_of_head").is_colliding():
			change_state.emit("Idle")
