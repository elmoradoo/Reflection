extends BaseState

var player: playerData
const max_speed: float = 3.0
var enums = preload("res://scripts/player/enums.gd")
var velocity_before_landing: Vector3

const roll_min_velocity = -8

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.AirTime

func enter():
	velocity_before_landing = player.velocity

func exit():
	player.animation_player.play("land")

func update():
	super.update_event(player)
	super.reset_head_bob(player)
	velocity_before_landing = player.velocity

func get_next_state():
	if player.myself.is_on_floor():
		if velocity_before_landing.y <= roll_min_velocity and Input.is_action_pressed("crouch"):
			return enums.player_states.Rolling
		return enums.player_states.Idle
	elif super.can_ledgeclimb(player):
		return enums.player_states.LedgeClimb
	elif super.can_ledge_grab(player):
		return enums.player_states.LedgeGrab
	elif super.can_vault(player):
		return enums.player_states.Vault
	elif super.can_wallclimb(player):
		return enums.player_states.WallClimb
	elif super.can_wallrun(player):
		return enums.player_states.WallRun

	return enums.player_states.AirTime
