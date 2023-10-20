extends Node

var player
const max_speed: float = 5.0

func init(obj):
	player = obj

func enter():
	pass

func update():
	player.velocity.y -= player.gravity * player.delta

func exit():
	pass

func check():
	pass
