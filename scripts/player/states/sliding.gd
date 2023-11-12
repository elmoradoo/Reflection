extends BaseState


const max_speed: float = 5.0
var enums = preload("res://scripts/player/enums.gd")

const sliding_initial_force: float = 1.2
const min_sliding_speed: float = 4

func get_state_name():
	return enums.player_states.Sliding

func enter():
	player.model.get_node("AnimationPlayer").play("sliding")
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x *= sliding_initial_force
	player.velocity.z *= sliding_initial_force

func update():
	super.stand_down()
	player.velocity.x = lerp(player.velocity.x, 0.0, player.delta * 1)
	player.velocity.z = lerp(player.velocity.z, 0.0, player.delta * 1)

func exit():
	pass

func update_event(event: InputEvent):
	super.update_event(event)
	if event is InputEventKey:
		if event.is_action_released("crouch"):
			if not player.raycasts.get_node("top_of_head").is_colliding():
				return enums.player_states.Idle
			else:
				return enums.player_states.Crouching


func get_next_state():
	if player.velocity.length() > min_sliding_speed:
		return enums.player_states.Sliding
	else:
		return enums.player_states.Crouching
