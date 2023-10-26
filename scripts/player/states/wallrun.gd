extends BaseState

var player: playerData
var enums = preload("res://scripts/player/enums.gd")

var old_vel: Vector3 = Vector3.ZERO
func init(obj):
	player = obj

func enter():
	old_vel = player.velocity
	

func exit():
	player.velocity = old_vel

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

#Raycast front wall (2 ?)
#If enough upwards velocity in airtime
#Timer for max climb duration

func update():
	update_event()
	player.velocity.y += 0.3
	
func check():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		player.current_state = enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		player.current_state = enums.player_states.Idle		
	elif player.velocity.y >= 6 and not player.raycasts.get_node("front_of_feets").is_colliding():
		player.current_state = enums.player_states.AirTime
	
