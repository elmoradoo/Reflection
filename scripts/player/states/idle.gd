extends State

@export var idle_lerp_speed: float = 2.0 

var raycasts_left: Array[RayCast3D] = []
var raycasts_right: Array[RayCast3D] = []

func init(player_obj: Player):
	super.init(player_obj)
	# Number of raycasts
	var num_raycasts: int = 40
	# Create and position raycasts
	for i in range(num_raycasts):
		var raycast_left: RayCast3D = RayCast3D.new()
		var raycast_right: RayCast3D = RayCast3D.new()
	# Set raycast properties
		raycast_left.position.x = 0.5
		raycast_left.target_position = Vector3(0, 0, -1)  # Adjust as needed
		raycast_left.enabled = true

		raycast_right.position.x = -0.5		
		raycast_right.target_position = Vector3(0, 0, -1)  # Adjust as needed
		raycast_right.enabled = true
		
		# Position raycasts above the previous one
		var height_offset: float = i * 0.1
		raycast_left.position.y = height_offset
		raycast_right.position.y = height_offset
		
		# Append the fully configured raycast to the array
		raycasts_left.append(raycast_left)
		raycasts_right.append(raycast_right)
		# Add the raycast as a child
		player.add_child(raycast_left)
		player.add_child(raycast_right)


func can_enter(_prev_state: String):
	return player.is_on_floor() and player.input_dir == Vector2.ZERO

func move_player():
	player.stand_up()
	player.reset_neck(2.0)
	player.reset_head_bob()
	player.velocity.x = move_toward(player.velocity.x, 0, idle_lerp_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, idle_lerp_speed)
	super.move_player()

var pressed_rotate: bool = false

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_pressed("rotate") and not pressed_rotate:
		pressed_rotate = true
		player.smooth_rotate(PI, 15.0)
	elif not player.is_rotating:
		pressed_rotate = false
