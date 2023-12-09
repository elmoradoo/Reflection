extends BaseState

var coiling: bool = true

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("coiling_time").timeout.connect(coiling_timer)
	
func coiling_timer():
	coiling = false

func enter():
	player.timers.get_node("coiling_time").start()
	player.coiling_collision_shape.disabled = false
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true

func exit():
	coiling = true
	player.timers.get_node("coiling_time").stop()
	player.coiling_collision_shape.disabled = true
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func move_player():
	super.move_player()

func check_input_next_state():
	if player.is_on_floor() and Input.is_action_pressed("crouch"):
		change_state.emit("Sliding")
	elif player.is_on_floor() and Input.is_action_pressed("forward"):
		change_state.emit("Sprinting")

func check_physics_next_state():
	if player.is_on_floor() or not coiling:
		change_state.emit("Idle")

