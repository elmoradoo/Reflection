extends Node

class_name State

var player: Player

signal collision
signal change_state


func init(player_obj: Player):
	player = player_obj

func update_mouse(event):
	if event is InputEventMouseMotion:
		player.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func check_input_next_state():
	player.input_dir = Input.get_vector("left", "right", "forward", "backward")

func _on_collision(_old_vel: Vector3, _collision: KinematicCollision3D):
	print(self.name + " collided with: " + str(_collision.get_collider_id()))

func move_player():
	var oldvel = player.velocity
	player.camera.fov = lerp(player.camera.fov, 75 + player.velocity.length(), 0.1)
	player.move_and_slide()
	if abs(oldvel.length() - player.velocity.length()) > 0:
		# collision happened!
		collision.emit(oldvel, player.get_last_slide_collision())
	if player.gravity_enabled and not player.is_on_floor():
		player.velocity.y -= player.gravity * player.delta
	elif player.is_on_floor():
		player.velocity.y = 0

func can_enter():
	return true

func can_change_to(state_name: String):
	return player.player_state_manager.state_nodes[state_name].can_enter()

func check_physics_next_state():
	pass

func exit():
	pass
