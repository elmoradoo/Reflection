extends BaseState

var enums = preload("res://scripts/player/enums.gd")

var idle_lerp_speed = 2.0 


func enter():
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func exit():
	pass

func get_state_name():
	return enums.player_states.Idle

func update():
	super.stand_up()
	super.reset_neck()
	super.reset_head_bob()
	player.velocity.x = move_toward(player.velocity.x, 0, idle_lerp_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, idle_lerp_speed)

func get_next_state():
	if player.is_on_floor():
		if Input.is_action_just_pressed("crouch"):
			return enums.player_states.Crouching
		elif Input.is_action_just_released("crouch") and not player.raycasts.get_node("top_of_head").is_colliding():
			return enums.player_states.Idle
		elif player.input_dir != Vector2.ZERO:
			return enums.player_states.Sprinting
		if Input.is_action_just_pressed("jump"):
			return enums.player_states.Jumping
	return enums.player_states.Idle
