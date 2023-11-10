extends BaseState

var player: playerData
const max_speed: float = 3.0
var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.AirTime

func enter():
	pass

func exit():
	player.animation_player.play("land")

func update():
	super.update_event(player)
	super.reset_head_bob(player)

func get_next_state():
	if player.myself.is_on_floor():
		if Input.is_action_just_pressed("crouch") and player.velocity.length() >= 1 and player.velocity.length() <= 10:
			return enums.player_states.Rolling
		return enums.player_states.Idle
	elif super.can_vault(player):
		return enums.player_states.Vault
	elif super.can_wallclimb(player):
		return enums.player_states.WallClimb
	elif super.can_wallrun(player):
		return enums.player_states.WallRun

	return enums.player_states.AirTime
