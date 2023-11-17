extends BaseState


const jump_velocity: float = 4.5
const forward_velocity: float = 1.1
var has_jumped: bool = false

func get_state_name():
	return enums.player_states.Jumping

func enter():
	if player.animation_player.is_playing():
		player.animation_player.play(player.animation_player.current_animation, -1, -1.5, false)
	player.animation_player.queue("jump")
	player.model.get_node("AnimationPlayer").play("jumping")

func exit():
	has_jumped = false

func move_player():
	super.reset_neck(2.0)
	has_jumped = true
	player.velocity.y += jump_velocity
	var forward = player.transform.basis.z.normalized()
	player.velocity.x += -forward.x * forward_velocity
	player.velocity.z += -forward.z * forward_velocity
	super.move_player()

func check_physics_next_state():
	if not has_jumped:
		return
	if not player.is_on_floor():
		change_state.emit(enums.player_states.AirTime)
