extends BaseState

var player: playerData
const max_speed: float = 5.0
var enums = preload("res://scripts/player/enums.gd")

const sliding_initial_force: float = 1.2
const min_sliding_speed: float = 4

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.Sliding

func enter():
	player.model.get_node("AnimationPlayer").play("sliding")
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x *= sliding_initial_force
	player.velocity.z *= sliding_initial_force

func update():
	super.update_event(player)
	super.stand_down(player)
	player.velocity.x = lerp(player.velocity.x, 0.0, player.delta * 1)
	player.velocity.z = lerp(player.velocity.z, 0.0, player.delta * 1)
	
func exit():
	pass

func get_next_state():
	if Input.is_action_just_released("crouch") and not player.raycasts.get_node("top_of_head").is_colliding():
		return enums.player_states.Idle
	elif Input.is_action_pressed("crouch") and player.velocity.length() <= min_sliding_speed:
		return enums.player_states.Crouching
	elif Input.is_action_pressed("crouch") and player.velocity.length() > min_sliding_speed:
		return enums.player_states.Sliding
	else:
		return enums.player_states.Crouching
