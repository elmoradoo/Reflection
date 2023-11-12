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

func update_event(event: InputEvent):
	super.update_event(event)
	if event is InputEventKey:
		if event.is_action_pressed("crouch"):
			return enums.player_states.Crouching
		elif event.is_action_pressed("jump"):
			return enums.player_states.Jumping

func get_next_state():
	if player.input_dir != Vector2.ZERO:
		return enums.player_states.Sprinting
	return enums.player_states.Idle
