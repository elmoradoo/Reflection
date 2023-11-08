extends BaseState

var enums = preload("res://scripts/player/enums.gd")
var player: playerData
const max_speed: float = 3.0

func init(obj):
	player = obj

func enter():
	pass

func exit():
	pass

func get_state_name():
	return enums.player_states.Crouching

func update():
	super.update_event(player)
	super.stand_down(player)
	if player.input_dir != Vector2.ZERO:
		super.head_bob(player, 0.1)
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed
	player.direction = lerp(player.direction, (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized(), lerp_speed * player.delta)

func get_next_state():
	if player.myself.is_on_floor():
		if Input.is_action_pressed("crouch") or player.raycasts.get_node("top_of_head").is_colliding():
			return enums.player_states.Crouching
		else:
			return enums.player_states.Idle
	return enums.player_states.NULL
