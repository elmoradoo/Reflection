extends State

@export var move_speed: float = 2.0

var wall_normal: Vector3 = Vector3.ZERO
var is_on_end: bool = false

func can_enter(_prev_state: String) -> bool:
	if not player.get_last_slide_collision():
		return false
	if (player.rc_torso.get_node("front").is_colliding() 
		and not player.rc_head.get_node("front").is_colliding()
		and player.velocity.y < 1):
		return true
	return false

func enter(_prev_state: String) -> void:
	if player.velocity.y < 0:
		player.velocity.y = 0
	player.gravity_enabled = false
	is_on_end = false
	# THIS CRASHES IF NULL
	wall_normal = player.get_last_slide_collision().get_normal()

func exit(_next_state: String) -> void:
	player.gravity_enabled = true

func move_player():
	var velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * move_speed
	# If we are on the end of the ledge, forbid to go further
	is_on_end = !player.test_move(player.transform, (velocity - wall_normal * velocity) * player.delta, null, 0.001, true)
	if is_on_end:
		return

	player.velocity = velocity - wall_normal * velocity
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_released("crouch"):
		change_state.emit("AirTime")
	elif Input.is_action_pressed("jump"):
		if can_change_to("LedgeClimb"):
			change_state.emit("LedgeClimb")
		else:
			change_state.emit("Jumping")
