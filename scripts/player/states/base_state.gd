extends Node

class_name BaseState

@export var player: Player

#Stand up vars
const stand_up_lp: float = 10.0

#Crouching vars
const crouching_depth: float = -0.5
const lerp_speed:float = 10.0

#Head bobbing vars
var head_bobbing_vector: Vector2 = Vector2.ZERO
var head_bobbing_index: float = 0.0
const head_bobbing_speed: float = 22.0
const head_bobbing_lerp: float = 10.0

#Climbing vars
const climbable_min_velocity: float = 4.0
const wallrun_min_velocity: float = 1.0

#Sliding vars
const sliding_minimum_velocity: float = 5.0

#Wallrun vars
const wallrun_jumping_velocity: float = 7.0

func init(player_obj: Player):
	player = player_obj

func stand_up():
	player.neck.rotation.y = lerp(player.neck.rotation.y, 0.0, player.delta * stand_up_lp)
	player.head.position.y = lerp(player.head.position.y, 0.0, stand_up_lp * player.delta)

func stand_down():
	player.head.position.y = lerp(player.head.position.y, crouching_depth, lerp_speed * player.delta)

func reset_neck():
	player.neck.rotation.x = lerp(player.neck.rotation.x, 0.0, player.delta * 2.0)

func head_bob(intensity):
	head_bobbing_index += head_bobbing_speed * player.delta
	head_bobbing_vector.y = sin(head_bobbing_index)
	head_bobbing_vector.x = sin(head_bobbing_index / 2) + 0.5
	player.eyes.position.y = lerp(player.eyes.position.y, head_bobbing_vector.y * (intensity / 2.0), player.delta * head_bobbing_lerp)
	player.eyes.position.x = lerp(player.eyes.position.x, head_bobbing_vector.x * intensity, player.delta * head_bobbing_lerp)
	
func reset_head_bob():
	player.eyes.position.y = lerp(player.eyes.position.y, 0.0, player.delta * head_bobbing_lerp)
	player.eyes.position.x = lerp(player.eyes.position.x, 0.0, player.delta * head_bobbing_lerp)

func update_event(event):
	if event is InputEventMouseMotion:
		player.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
		player.head.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
		player.head.rotation.x = clamp(player.head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func can_wallclimb() -> bool:
	if not player.rc_torso.get_node("front").is_colliding() or player.velocity.y < climbable_min_velocity:
		return false
	var collision = player.rc_torso.get_node("front").get_collision_normal()
	var ray_direction = player.rc_torso.get_node("front").global_transform.basis.z.normalized()
	var dot_product = abs(collision.dot(ray_direction))
	if dot_product < 0.8:
		return false
	else:
		return true

func can_wallrun() -> bool:
	if not player.rc_torso.get_node("front").is_colliding():
		return false
	var collision = player.rc_torso.get_node("front").get_collision_normal()
	var ray_direction = player.rc_torso.get_node("front").global_transform.basis.z.normalized()
	var dot_product = abs(collision.dot(ray_direction))
	if dot_product < 0.8:
		return true
	else:
		return false

func can_ledgeclimb() -> bool:
	if (player.rc_torso.get_node("front").is_colliding() 
		and not player.rc_head.get_node("front").is_colliding()
		and player.velocity.y > 1):
			return true
	return false
	
func can_vault() -> bool:
	if (player.rc_feets.get_node("front").is_colliding() 
		and not player.rc_head.get_node("front").is_colliding()
		and player.velocity.y > 1):
			return true
	return false

func can_ledge_grab() -> bool:
	if (player.rc_torso.get_node("front").is_colliding() 
		and not player.rc_head.get_node("front").is_colliding()
		and player.velocity.y < 1):
		return true
	return false
