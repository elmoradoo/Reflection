extends Node

var player
const jump_velocity: float = 4.5

func init(obj):
	player = obj

func enter(obj):
	player = obj

func update():
	player.velocity.y = jump_velocity

func exit():
	pass
