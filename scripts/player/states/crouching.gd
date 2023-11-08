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

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

func update():
	update_event()
	self.stand_down(player)
	self.head_bob(player, 0.1)
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
