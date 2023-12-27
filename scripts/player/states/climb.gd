extends State

@export var forward_goal = 1.0
@export var forward_speed = 4.0

var collided: bool = false
var old_velocity: Vector3
var old_position: Vector3
var target_position: Vector3
var climbing_type: String = "undefined"

func can_climb_above_shoulder() -> bool:
	return player.get_ledge_height() < player.shoulder_height * player.standing_height

func climb_above_shoulder():
	print("Shoulder")

func can_climb_above_torso() -> bool:
	return player.get_ledge_height() < player.torso_height * player.standing_height
	
func climb_above_torso():
	print("Torso")

func can_climb_above_waist() -> bool:
	return player.get_ledge_height() < player.waist_height * player.standing_height

func climb_above_waist():
	print("Waist")

func can_climb_above_knees() -> bool: 
	return player.get_ledge_height() < player.knees_height * player.standing_height

func climb_above_knees():
	print("Knees")

func can_climb_above_feet() -> bool:
	return player.get_ledge_height() < player.feet_height * player.standing_height

var tmp = false
func climb_above_feet():
	if true:
		player.gravity_enabled = false
		if player.position.y != target_position.y:
			player.position.y = move_toward(player.position.y, target_position.y, 5.0 * player.delta)
			#player.position.x = move_toward(player.position.x, -target_position.x, 1.0 * player.delta)
			#player.position.z = move_toward(player.position.z, -target_position.z, 1.0 * player.delta)
		else:
			player.position = player.position.move_toward(target_position, 5.0 * player.delta)

		if player.position == target_position:
			done = true
		tmp = true

func can_enter(_prev_state: String) -> bool:
	if player.get_ledge_height() == 0:
		return false
	if not player.get_last_slide_collision():
		return false
	if can_climb_above_feet():
		climbing_type = "can_climb_above_feet"
		return true
	elif can_climb_above_knees():
		climbing_type = "can_climb_above_knees"
		return true
	elif can_climb_above_waist():
		climbing_type = "can_climb_above_waist"
		return true
	elif can_climb_above_torso():
		climbing_type = "can_climb_above_torso"
		return true
	elif can_climb_above_shoulder():
		climbing_type = "can_climb_above_shoulder"
		return true
	return false


func enter(_prev_state: String) -> void:
	old_velocity = player.velocity
	player.velocity = Vector3.ZERO
	old_position = player.position
	var forward = player.transform.basis.z.normalized()
	player.position.x += -forward.x * 1.0
	player.position.z += -forward.z * 1.0
	target_position = Vector3\
	(player.position.x + -forward.x * 1.0,\
	player.position.y + player.get_ledge_height(),\
	player.position.z + -forward.z * 1.0)
	player.collision_shape.disabled = true

func exit(_next_state: String) -> void:
	player.gravity_enabled = true
	player.velocity = old_velocity
	player.velocity.y = 0
	tmp = false
	player.collision_shape.disabled = false	
func update_mouse(event):
	if event is InputEventMouseMotion:
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		player.neck.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.neck.rotation.y = clamp(player.neck.rotation.y, deg_to_rad(-44.5), deg_to_rad(44.5))

var done = false
func move_player():
	#if climbing_type == "can_climb_above_feet":
	climb_above_feet()
	if done:
		done = false
		change_state.emit("Idle")
	super.move_player()
