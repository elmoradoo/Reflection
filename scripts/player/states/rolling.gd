extends BaseState


var old_vel: Vector3 = Vector3.ZERO
var is_rolling = true

func init(obj):
	super.init(obj)
	player.timers.get_node("roll_time").timeout.connect(timer_end)

func timer_end():
	is_rolling = false

func get_state_name():
	return enums.player_states.Rolling

func enter():
	old_vel = player.velocity
	is_rolling = true
	player.timers.get_node("roll_time").start()
	player.animation_player.play("roll")

func exit():
	player.velocity = old_vel
	player.velocity.y = 0

func move_player():
	super.move_player()

func get_physics_next_state():
	if not is_rolling:
		return enums.player_states.Idle
	return enums.player_states.Rolling
	
