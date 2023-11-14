extends BaseState


const jump_velocity: float = 4.5
const forward_velocity: float = 1.0

func get_state_name():
	return enums.player_states.Jumping

func enter():
	player.animation_player.queue("jump")
	player.model.get_node("AnimationPlayer").play("jumping")

func move_player():
	super.reset_neck(2.0)
	player.velocity.y += jump_velocity
	var forward = player.transform.basis.z.normalized()
	player.position.x = lerp(player.position.x, player.position.x + (-forward.x * 4.0), forward_velocity * player.delta)
	player.position.z = lerp(player.position.z, player.position.z + (-forward.z * 4.0), forward_velocity * player.delta)
	super.move_player()


func exit():
	pass

func get_physics_next_state():
	if not player.is_on_floor():
		return enums.player_states.AirTime
	return enums.player_states.Jumping
