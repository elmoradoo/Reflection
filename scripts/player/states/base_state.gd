extends Node

class_name BaseState

#Stand up vars
var stand_up_lp = 10.0

#Crouching vars
var crouching_depth: float = -0.5
var lerp_speed = 10.0

#Head bobbing vars
var head_bobbing_vector: Vector2 = Vector2.ZERO
var head_bobbing_index: float = 0.0
var head_bobbing_speed: float = 22.0
var head_bobbing_lerp: float = 10.0

func stand_up(player: playerData):
	player.neck.rotation.y = lerp(player.neck.rotation.y, 0.0, player.delta * stand_up_lp)
	player.head.position.y = lerp(player.head.position.y, 0.0, stand_up_lp * player.delta)
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func stand_down(player: playerData):
	player.head.position.y = lerp(player.head.position.y, crouching_depth, lerp_speed * player.delta)
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false

func reset_neck(player: playerData):
	player.neck.rotation.x = lerp(player.neck.rotation.x, 0.0, player.delta * 2.0)

func head_bob(player: playerData, intensity):
	head_bobbing_index += head_bobbing_speed * player.delta
	head_bobbing_vector.y = sin(head_bobbing_index)
	head_bobbing_vector.x = sin(head_bobbing_index / 2) + 0.5
	player.eyes.position.y = lerp(player.eyes.position.y, head_bobbing_vector.y * (intensity / 2.0), player.delta * head_bobbing_lerp)
	player.eyes.position.x = lerp(player.eyes.position.x, head_bobbing_vector.x * intensity, player.delta * head_bobbing_lerp)
	
func reset_head_bob(player: playerData):
	player.eyes.position.y = lerp(player.eyes.position.y, 0.0, player.delta * head_bobbing_lerp)
	player.eyes.position.x = lerp(player.eyes.position.x, 0.0, player.delta * head_bobbing_lerp)
