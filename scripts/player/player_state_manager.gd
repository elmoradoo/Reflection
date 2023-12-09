class_name StateManager extends Node

var current_state: State
var player: Player

@export var initial_state: Node

var state_nodes = {}

func debug_print_player_state():
	print(current_state.name)

func _ready():
	assert(initial_state != null)

func init(player_obj):
	player = player_obj
	for state in get_children():
		state.init(player)
		state.connect("change_state", _on_change_state)
		state_nodes[state.name] = state
	current_state = initial_state
	print(current_state)
	current_state.connect("collision", current_state._on_collision)

	#Get mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_change_state(next_state):
	if next_state and next_state != current_state.name:
		current_state.exit()
		current_state.disconnect("collision", current_state._on_collision)
		current_state = state_nodes[next_state]
		current_state.connect("collision", current_state._on_collision)
		current_state.enter()
		debug_print_player_state()


func update_event(event):
	if not UI.IS_FOCUSED and event is InputEventMouseMotion:
		current_state.update_mouse(event)


func run():
	# Handle player inputs only of UI is not focused.
	if not UI.IS_FOCUSED:
		current_state.check_input_next_state()

	# Change state depending on physics, does not care about UI
	current_state.check_physics_next_state()

	current_state.move_player()
