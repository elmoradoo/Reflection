extends State

var velocity_before_landing: Vector3
const roll_min_velocity: float = -8.0
var collided: bool = false

func _on_collision(previous_vel: Vector3, new_collision: KinematicCollision3D):
	super._on_collision(previous_vel, new_collision)
	collided = true

func enter():
	velocity_before_landing = player.velocity
	player.model.get_node("AnimationPlayer").queue("basic/fall")

func exit():
	player.animation_player.play("land")
	collided = false

func move_player():
	super.reset_head_bob()
	velocity_before_landing = player.velocity
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch") and player.is_on_floor() and velocity_before_landing.y <= roll_min_velocity:
		change_state.emit("Rolling")
	elif super.can_coil():
		change_state.emit("Coiling")
	elif player.is_on_floor() and Input.is_action_pressed("forward"):
		change_state.emit("Sprinting")

func check_physics_next_state():
	if player.is_on_floor() and velocity_before_landing.y < -5:
		var forward = player.transform.basis.z.normalized()
		player.position.x = lerp(player.position.x, player.position.x + (-forward.x * 4.0), 2.0 * player.delta)
		player.position.z = lerp(player.position.z, player.position.z + (-forward.z * 4.0), 2.0 * player.delta)
		change_state.emit("Sprinting")
	elif player.is_on_floor():
		change_state.emit("Idle")
	elif super.can_ledge_grab() and collided:
		change_state.emit("LedgeGrab")
	elif super.can_ledgeclimb() and collided:
		change_state.emit("LedgeClimb")
	elif super.can_climb():
		change_state.emit("Climb")
	elif super.can_vault():
		change_state.emit("Vault")
	elif super.can_wallclimb() and collided:
		change_state.emit("WallClimb")
	elif super.can_wallrun():
		change_state.emit("WallRun")

