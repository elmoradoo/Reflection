extends State


@export var jump_velocity: float = 4.5
@export var forward_velocity: float = 1.1

var has_jumped: bool = false

func can_enter(_prev_state: String):
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor():
			return true
		# Allow only one jump if on a wall
		elif player.is_on_wall():
			return player.touched_floor
	return false

func enter(_prev_state: String) -> void:
	player.model_anim.play("basic/jump")
	if player.animation_player.is_playing():
		var current_frame = player.animation_player.current_animation_position
		# increase speed
		player.animation_player.play(player.animation_player.current_animation, -1, 2, false)
		player.animation_player.seek(current_frame)
	player.animation_player.queue("jump")

func exit(_next_state: String) -> void:
	has_jumped = false

func move_player():
	player.reset_neck(2.0)
	has_jumped = true
	player.velocity.y += jump_velocity
	var forward = player.transform.basis.z.normalized()
	player.velocity.x += -forward.x * forward_velocity
	player.velocity.z += -forward.z * forward_velocity
	super.move_player()

func check_physics_next_state():
	if not has_jumped:
		return
	super.check_physics_next_state()
