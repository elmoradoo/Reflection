extends BaseState

var enums = preload("res://scripts/player/enums.gd")

var player: playerData

func init(obj):
	player = obj

func enter():
	pass

func update():
	super.update_event(player)

func exit():
	pass

func get_state_name():
	return enums.player_states.Vault

func get_next_state():
	return enums.player_states.Vault  
