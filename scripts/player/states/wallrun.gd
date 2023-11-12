extends BaseState


var enums = preload("res://scripts/player/enums.gd")

var old_vel: Vector3 = Vector3.ZERO
var old_rotation_head: Vector3 = Vector3.ZERO

var is_jumping: bool = false

const base_wallrun_speed: float = 1

var first_collision_travel: Vector3 = Vector3.ZERO


func get_state_name():
	return enums.player_states.WallRun


func enter():
	old_vel = player.velocity
	player.timers.get_node("wallrun_time").start()
	#first_collision_travel = player.get_last_slide_collision().get_travel().rotated(Vector3(0, 1, 0), 0.5)
	#var speed_vector =  first_collision_travel# + 
	#print("collision_travel :" + str(speed_vector))
	player.velocity.dot(player.get_last_slide_collision().get_remainder())
	print("original velocity: " + str(player.velocity))
	#player.velocity -= speed_vector
	#print("corrected velocity: " + str(player.velocity))
	
	player.velocity.y += 0.5

	#old_rotation_head = player.head.get_rotation()


func exit():
	player.velocity = old_vel
	player.velocity.y = 0
	#print()
	#var total_rotation = player.head.get_rotation() - old_rotation_head
	#var player_rotation = player.get_rotation() * Vector3(total_rotation.x, 0, total_rotation.z)
	#print(old_rotation_head)
	#print(old_rotation_head - )
	#player.set_rotation(-player_rotation)
	#player.head.set_rotation(-player_rotation)

	#if is_jumping:
	#	player.velocity = \
	#		(player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * \
	#		(wallrun_jumping_velocity + player.timers.get_node("wallrun_time").time_left)
	#	is_jumping = false
	player.timers.get_node("wallrun_time").stop()
#Raycast front wall (2 ?)
#If enough upwards velocity in airtime

func update():
	#print("new velocity: " + str(player.velocity))
	#print("remainder: " + str(player.get_last_slide_collision().get_remainder()))
	print(player.get_wall_normal())
	#print(player.head.get_rotation())
	#print(player.get_rotation())
	#print("collision inverse: " + str(collision_normal))

	#player.velocity.y += * player.timers.get_node("wallrun_time").time_left


#func update_event(player: playerData):
#	if player.event is InputEventMouseMotion:
#		player.rotate_y(deg_to_rad(-player.event.relative.x * player.mouse_sensitivity))
		#player.rotation.y = #clamp(player.head.rotation.y, deg_to_rad(89), deg_to_rad(-89))
		#player.head.rotate_x(deg_to_rad(-player.event.relative.y * player.mouse_sensitivity))
		#player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
#	player.event = null

func get_next_state():
	if player.is_on_floor() and player.velocity.length() >= 2:
		return enums.player_states.Sprinting
	elif player.is_on_floor():
		return enums.player_states.Idle
	elif Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		return enums.player_states.Jumping
	elif super.can_wallrun():
		return enums.player_states.WallRun
	return enums.player_states.WallRun
	
