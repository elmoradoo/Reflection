extends State


var old_vel: Vector3 = Vector3.ZERO
var is_rolling: bool = true


func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("roll_time").timeout.connect(timer_end)

func timer_end():
	is_rolling = false

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

func check_physics_next_state():
	if not is_rolling:
		change_state.emit("Idle")

