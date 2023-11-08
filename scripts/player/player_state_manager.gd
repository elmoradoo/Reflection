extends Node

var enums = preload("res://scripts/player/enums.gd")

var player: playerData

var current_state
var next_state

var state_scripts = {
	enums.player_states.Idle: preload("res://scripts/player/states/idle.gd").new(),
	enums.player_states.Walking: preload("res://scripts/player/states/walking.gd").new(),
	enums.player_states.Sprinting: preload("res://scripts/player/states/sprinting.gd").new(),
	enums.player_states.Crouching: preload("res://scripts/player/states/crouching.gd").new(),
	enums.player_states.Sliding: preload("res://scripts/player/states/sliding.gd").new(),
	enums.player_states.Jumping: preload("res://scripts/player/states/jumping.gd").new(),
	enums.player_states.AirTime: preload("res://scripts/player/states/airtime.gd").new(),
	enums.player_states.WallClimb: preload("res://scripts/player/states/wallclimb.gd").new(),
	enums.player_states.WallRun: preload("res://scripts/player/states/wallrun.gd").new(),
	enums.player_states.LedgeGrab: preload("res://scripts/player/states/ledgegrab.gd").new(),
}

func debug_print_player_state():
	print(enums.player_states.keys()[player.current_state.get_state_name()])

func init(player_object):
	player = player_object
	for state_script in state_scripts.values():
		state_script.init(player)
	player.current_state = state_scripts[enums.player_states.Idle]

func run():
	next_state = player.current_state.get_next_state()
	if next_state != player.current_state.get_state_name():
		player.current_state.exit()
		player.current_state = state_scripts[next_state]
		player.current_state.enter()
		debug_print_player_state()
	player.current_state.update()
