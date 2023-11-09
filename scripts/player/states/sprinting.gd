extends BaseState

var player: playerData
const max_speed: float = 8.0
#var lerp_speed: float = 0.5

var acceleration = 5.0

var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.Sprinting

func enter():
	player.model.get_node("AnimationPlayer").play("running")

func update():
	super.update_event(player)
	super.stand_up(player)
	super.head_bob(player, 0.2)
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	
func exit():
	pass

func get_next_state():
	if player.myself.is_on_floor():
		if Input.is_action_pressed("crouch") and player.velocity.length() >= player.sliding_minimum_velocity:
			return enums.player_states.Sliding
		elif Input.is_action_pressed("crouch"):
			return enums.player_states.Crouching
		elif player.input_dir == Vector2.ZERO:
			return enums.player_states.Idle
		if Input.is_action_just_pressed("jump"):
			return enums.player_states.Jumping
		return enums.player_states.Sprinting
	else:
		return enums.player_states.AirTime
		
