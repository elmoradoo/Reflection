extends State


@export var roll_min_velocity: float = -8.0

var old_vel: Vector3 = Vector3.ZERO
var is_rolling: bool = true


func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("roll_time").timeout.connect(timer_end)

func timer_end():
	is_rolling = false

func can_enter(_prev_state: String) -> bool:
	return Input.is_action_pressed("crouch") and not player.is_on_floor() and not player.is_on_wall() and player.velocity.y <= roll_min_velocity

func enter(_prev_state: String) -> void:
	old_vel = player.velocity
	is_rolling = true
	player.timers.get_node("roll_time").start()
	player.animation_player.play("roll")

func exit(_next_state: String) -> void:
	player.velocity = old_vel
	player.velocity.y = 0

func move_player():
	super.move_player()
