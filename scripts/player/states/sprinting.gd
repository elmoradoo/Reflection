extends Node

var player
const max_speed: float = 8.0

func init(obj):
	player = obj

func enter(obj):
	player = obj

func update():
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed

func exit():
	print("cleanuip")
