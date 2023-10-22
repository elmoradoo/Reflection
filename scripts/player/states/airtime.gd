extends Node

var player: playerData
const max_speed: float = 5.0
var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func enter():
	pass

func exit():
	pass

func update():
	pass

func check():
	if player.myself.is_on_floor():
		player.current_state = enums.player_states.Idle
