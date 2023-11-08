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
	pass

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

func update():
	update_event()
	self.stand_up(player)
	self.head_bob(player, 0.2)
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
		
