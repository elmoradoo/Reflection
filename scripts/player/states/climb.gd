extends BaseState

func enter():
	pass

func exit():
	pass

func get_state_name():
	return enums.player_states.Climb

func move_player():
	super.move_player()

func check_input_next_state():
	pass

func check_physics_next_state():
	pass
