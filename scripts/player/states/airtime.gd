extends BaseState

var player: playerData
const max_speed: float = 3.0
var enums = preload("res://scripts/player/enums.gd")
var climbable_min_velocity = 2.0

func init(obj):
	player = obj

func enter():
	pass

func exit():
	player.animation_player.play("land")

func update_event():
	if player.event is InputEventMouseMotion:
		player.myself.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		player.neck.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	player.event = null

func update():
	update_event()
	self.reset_head_bob(player)
	#print(player.velocity.y)


func can_wallclimb() -> bool:
	if (not player.myself.is_on_floor() 
		and player.raycasts.get_node("front_of_feets").is_colliding() 
		and player.velocity.y > climbable_min_velocity
		and player.raycasts.get_node("half_left_of_feets").is_colliding() 
		and player.raycasts.get_node("half_right_of_feets").is_colliding()):
		return true
	return false
	
func can_wallrun() -> bool:
	if (not player.myself.is_on_floor() 
		and player.raycasts.get_node("front_of_feets").is_colliding() 
		and player.velocity.y > climbable_min_velocity
		and (player.raycasts.get_node("half_left_of_feets").is_colliding() or player.raycasts.get_node("half_right_of_feets").is_colliding())):
			return true
	return false
	
func check():
	if player.myself.is_on_floor() and player.velocity.length() >= 2:
		player.current_state = enums.player_states.Sprinting
	elif player.myself.is_on_floor():
		player.current_state = enums.player_states.Idle		
	if can_wallclimb():
		player.current_state = enums.player_states.WallClimb
	elif can_wallrun():
		player.current_state = enums.player_states.WallRun
		