extends BaseState

var player: playerData
const jump_velocity: float = 4.5
var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.Jumping

func enter():
	player.animation_player.play("jump")

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null


func update():
	update_event()
	
	#Set eyes to 0
	player.eyes.position.x = lerp(player.eyes.position.x, 0.0, player.delta * 1)
	player.eyes.position.y = lerp(player.eyes.position.x, 0.0, player.delta * 1)
	player.velocity.y += jump_velocity


func exit():
	pass

func get_next_state():
	if not player.myself.is_on_floor():
		return enums.player_states.AirTime
	return enums.player_states.NULL
