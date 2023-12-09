extends State

@export var roll_min_velocity: float = -8.0

var velocity_before_landing: Vector3
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
	player.reset_head_bob()
	velocity_before_landing = player.velocity
	super.move_player()

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_pressed("crouch") and player.is_on_floor() and velocity_before_landing.y <= roll_min_velocity:
		change_state.emit("Rolling")
	elif can_change_to("Coiling"):
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
	elif can_change_to("LedgeGrab") and collided:
		change_state.emit("LedgeGrab")
	elif can_change_to("LedgeClimb") and collided:
		change_state.emit("LedgeClimb")
	elif can_change_to("Climb"):
		change_state.emit("Climb")
	elif can_change_to("Vault"):
		change_state.emit("Vault")
	elif can_change_to("WallClimb") and collided:
		change_state.emit("WallClimb")
	elif can_change_to("WallRun"):
		change_state.emit("WallRun")

