extends State

@export var idle_lerp_speed: float = 2.0 

func can_enter(_prev_state: String):
	return player.is_on_floor() and player.input_dir == Vector2.ZERO

func move_player():
	player.stand_up()
	player.reset_neck(2.0)
	player.reset_head_bob()
	player.velocity.x = move_toward(player.velocity.x, 0, idle_lerp_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, idle_lerp_speed)
	super.move_player()
