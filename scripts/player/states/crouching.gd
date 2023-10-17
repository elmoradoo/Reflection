extends Node

var player
const max_speed: float = 3.0
var crouching_depth: float = -0.5

func init(obj):
	player = obj

func enter(obj):
	player = obj

func update():
	#head.position.y = lerp(head.position.y, crouching_depth, lerp_speed * delta)
	player.head.position.y = crouching_depth
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = false
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed

func exit():
	print("cleanuip")
