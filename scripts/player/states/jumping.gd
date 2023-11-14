extends BaseState


const jump_velocity: float = 4.5
const forward_velocity: float = 1.1

func get_state_name():
	return enums.player_states.Jumping

func enter():
	player.animation_player.queue("jump")
	player.model.get_node("AnimationPlayer").play("jumping")

func move_player():
	super.reset_neck(2.0)
	player.velocity.y += jump_velocity
	var forward = player.transform.basis.z.normalized()
	player.velocity.x += -forward.x * forward_velocity
	player.velocity.z += -forward.z * forward_velocity
	super.move_player()

func exit():
	pass

func get_physics_next_state():
	if not player.is_on_floor():
		return enums.player_states.AirTime
	return enums.player_states.Jumping
