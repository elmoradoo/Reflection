extends State

@export var sliding_initial_force: float = 1.2
@export var min_sliding_speed: float = 4
@export var max_sliding_speed: float = 15

var previous_y = 0
var crouch_released = false

func can_enter(_prev_state: String) -> bool:
	return Input.is_action_pressed("crouch") and player.is_on_floor() and player.velocity.length() >= min_sliding_speed

func enter(_prev_state: String) -> void:
	player.model.get_node("AnimationPlayer").play("basic/sliding")
	player.velocity.x *= sliding_initial_force
	player.velocity.z *= sliding_initial_force
	previous_y = player.position.y
	crouch_released = false
	player.floor_snap_length = 0.5

func move_player():
	player.stand_down()
	var sign_x = signf(player.velocity.x)
	var sign_z = signf(player.velocity.z)
	if previous_y > player.position.y + 0.01:
		player.velocity.x = sign_x * clamp(lerp(abs(player.velocity.x), max_sliding_speed, player.delta * 0.05), 0, max_sliding_speed)
		player.velocity.z = sign_z * clamp(lerp(abs(player.velocity.z), max_sliding_speed, player.delta * 0.05), 0, max_sliding_speed)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.delta)
		player.velocity.z = lerp(player.velocity.z, 0.0, player.delta)
	previous_y = player.position.y
	super.move_player()

func exit(_next_state: String):
	player.floor_snap_length = 0.1

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_released("crouch"):
		crouch_released = true
		if not player.raycasts.get_node("top_of_head").is_colliding():
			change_state.emit("Idle")
		else:
			change_state.emit("Crouching")
