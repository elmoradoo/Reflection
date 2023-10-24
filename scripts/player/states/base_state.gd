extends Node

class_name BaseState

#Stand up vars
var stand_up_lp = 10.0

#Crouching vars
var crouching_depth: float = -0.5
var lerp_speed = 10.0

func stand_up(player: playerData):
	player.neck.rotation.y = lerp(player.neck.rotation.y, 0.0, player.delta * stand_up_lp)
	player.head.position.y = lerp(player.head.position.y, 0.0, stand_up_lp * player.delta)
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func stand_down(player: playerData):
	player.head.position.y = lerp(player.head.position.y, crouching_depth, lerp_speed * player.delta)
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
