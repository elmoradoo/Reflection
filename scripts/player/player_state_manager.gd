extends Node


var enums = preload("res://scripts/player/enums.gd")
var current_state: BaseState


var player: Player


var state_scripts = {
	enums.player_states.Idle: preload("res://scripts/player/states/idle.gd").new(),
	enums.player_states.Sprinting: preload("res://scripts/player/states/sprinting.gd").new(),
	enums.player_states.Crouching: preload("res://scripts/player/states/crouching.gd").new(),
	enums.player_states.Sliding: preload("res://scripts/player/states/sliding.gd").new(),
	enums.player_states.Jumping: preload("res://scripts/player/states/jumping.gd").new(),
	enums.player_states.AirTime: preload("res://scripts/player/states/airtime.gd").new(),
	enums.player_states.WallClimb: preload("res://scripts/player/states/wallclimb.gd").new(),
	enums.player_states.WallRun: preload("res://scripts/player/states/wallrun.gd").new(),
	enums.player_states.LedgeGrab: preload("res://scripts/player/states/ledgegrab.gd").new(),
	enums.player_states.LedgeClimb: preload("res://scripts/player/states/ledgeclimb.gd").new(),
	enums.player_states.Vault: preload("res://scripts/player/states/vault.gd").new(),
	enums.player_states.Rolling: preload("res://scripts/player/states/rolling.gd").new(),
}

func debug_get_player_state():
	return enums.player_states.keys()[current_state.get_state_name()]

func debug_print_player_state():
	print(enums.player_states.keys()[current_state.get_state_name()])

func init(player_obj):
	player = player_obj
	for state_script in state_scripts.values():
		state_script.init(player)
	current_state = state_scripts[enums.player_states.Idle]
	#Get mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func change_state(next_state):
	if next_state and next_state != current_state.get_state_name():
		current_state.exit()
		current_state.disconnect("collision", current_state._on_collision)
		current_state = state_scripts[next_state]
		current_state.connect("collision", current_state._on_collision)
		current_state.enter()
		debug_print_player_state()


func update_event(event):
	if not UI.IS_FOCUSED and event is InputEventMouseMotion:
		current_state.update_mouse(event)


func run():
	# Handle player inputs only of UI is not focused.
	if not UI.IS_FOCUSED:
		change_state(current_state.get_input_next_state())

	# Change state depending on physics, does not care about UI
	change_state(current_state.get_physics_next_state())
	
	# Prepare collision handling
	var previous_velocity = player.velocity

	current_state.move_player()
