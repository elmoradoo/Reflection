extends Node

var player
const max_speed: float = 5.0
var crouching_depth: float = -0.5
var lerp_speed = 10.0

#Unused
const sliding_initial_force: float = 9.0

func init(obj):
	player = obj

func enter():
	pass

func update():
	player.head.position.y = lerp(player.head.position.y, crouching_depth, lerp_speed * player.delta)
	#player.head.position.y = crouching_depth
	player.free_looking = true
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x = move_toward(player.velocity.x, 0, max_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, max_speed)

func exit():
	pass
