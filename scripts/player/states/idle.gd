extends State

@export var idle_lerp_speed: float = 2.0 

func enter():
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func move_player():
	player.stand_up()
	player.reset_neck(2.0)
	player.reset_head_bob()
	player.velocity.x = move_toward(player.velocity.x, 0, idle_lerp_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, idle_lerp_speed)
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch"):
		change_state.emit("Crouching")
	elif Input.is_action_pressed("jump"):
		change_state.emit("Jumping")

func check_physics_next_state():
	if player.input_dir != Vector2.ZERO:
		change_state.emit("Sprinting")
