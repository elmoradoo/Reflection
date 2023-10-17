extends Node

var player
const max_speed: float = 5.0

func init(obj):
	player = obj

func enter(obj):
	player = obj

func update():
	player.velocity.x = player.direction.x * max_speed
	player.velocity.z = player.direction.z * max_speed
	print(str(player.velocity) + " is " + str(player.direction.z * max_speed))
	#player.velocity.x = player.direction.x * max_speed
	#player.velocity.vel.z = player.direction.z * max_speed

func exit():
	print("cleanuip")
