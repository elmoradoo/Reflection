extends State

@export var roll_min_velocity: float = -8.0

var old_vel: Vector3 = Vector3.ZERO
var is_rolling: bool = true

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("roll_time").timeout.connect(func() : is_rolling = false)

#region Rolling

func can_roll() -> bool:
	return Input.is_action_pressed("crouch") and not player.is_on_floor() and not player.is_on_wall() and player.velocity.y <= roll_min_velocity

func start_roll() -> void:
	is_rolling = true
	player.timers.get_node("roll_time").start()
	player.animation_player.play("roll")
	
#endregion

func can_boost_land() -> bool:
	return false

func can_enter(_prev_state: String) -> bool:
	if can_roll():
		return true
	elif can_boost_land():
		return true
	elif player.is_on_floor():
		return true
	return false

func enter(_prev_state: String) -> void:
	if can_roll():
		start_roll()
	old_vel = player.velocity

func exit(_next_state: String) -> void:
	player.velocity = old_vel
	player.velocity.y = 0

func move_player():
	super.move_player()
