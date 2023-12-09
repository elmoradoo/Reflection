extends State

@export var forward_goal = 1.0
@export var forward_speed = 4.0

var collided: bool = false
var old_vel: Vector3

func can_enter(_prev_state: String) -> bool:
	return can_change_to("Vault") and player.rc_head.get_node("front_obstacle").is_colliding()

func enter(_prev_state: String) -> void:
	old_vel = player.velocity
	if player.get_last_slide_collision():
		collided = true

func exit(_next_state: String) -> void:
	player.gravity_enabled = true
	collided = false
	player.velocity = old_vel
	player.velocity.y = 0

func _on_collision(previous_vel: Vector3, new_collision: KinematicCollision3D):
	super._on_collision(previous_vel, new_collision)
	player.gravity_enabled = false
	if not collided:
		player.velocity = Vector3.ZERO
	collided = true

func update_mouse(event):
	if event is InputEventMouseMotion:
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		player.neck.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.neck.rotation.y = clamp(player.neck.rotation.y, deg_to_rad(-44.5), deg_to_rad(44.5))

func move_player():
	if not collided:
		super.move_player()
		return
	if player.rc_feets.get_node("front").is_colliding():# or player.rc_feets.get_node("downfront").is_colliding():
		player.position.y += 7.0 * player.delta
	else:
		var forward_direction = player.global_transform.basis.z
		player.position.x = lerp(player.position.x, player.position.x + forward_goal , -forward_direction.x * forward_speed * player.delta)
		player.position.z = lerp(player.position.z, player.position.z + forward_goal, -forward_direction.z * forward_speed * player.delta)
		if player.rc_feets.get_node("down").is_colliding():
			player.gravity_enabled = true
	super.move_player()
