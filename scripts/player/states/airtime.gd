extends BaseState


const max_speed: float = 3.0
var enums = preload("res://scripts/player/enums.gd")
var velocity_before_landing: Vector3

const roll_min_velocity = -8


func get_state_name():
	return enums.player_states.AirTime

func enter():
	velocity_before_landing = player.velocity

func exit():
	player.animation_player.play("land")

func update():
	super.reset_head_bob()
	#velocity_before_landing = player.velocity

func get_next_state():
	if player.is_on_floor():
		if velocity_before_landing.y <= roll_min_velocity and Input.is_action_pressed("crouch"):
			return enums.player_states.Rolling
		return enums.player_states.Idle
	elif super.can_ledgeclimb():
		return enums.player_states.LedgeClimb
	elif super.can_ledge_grab():
		return enums.player_states.LedgeGrab
	elif super.can_vault():
		return enums.player_states.Vault
	elif super.can_wallclimb():
		return enums.player_states.WallClimb
	elif super.can_wallrun():
		player.velocity = velocity_before_landing
		print("Airtime velocity: " + str(velocity_before_landing))
		return enums.player_states.WallRun

	return enums.player_states.AirTime
