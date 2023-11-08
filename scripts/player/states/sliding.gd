extends BaseState

var player: playerData
const max_speed: float = 5.0
var enums = preload("res://scripts/player/enums.gd")

const sliding_initial_force: float = 1.2

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.Sliding

func enter():
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
	if Input.is_action_just_released("crouch"):
		return enums.player_states.Idle
	elif Input.is_action_pressed("crouch") and player.velocity.length() <= 4:
		return enums.player_states.Crouching
	elif Input.is_action_pressed("crouch"):
		return enums.player_states.Sliding
	else:
		return enums.player_states.NULL
