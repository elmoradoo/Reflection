extends State

var coiling: bool = true

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("coiling_time").timeout.connect(coiling_timer)

func coiling_timer():
	coiling = false

func can_enter(_prev_state: String) -> bool:
	if Input.is_action_pressed("crouch") and player.velocity.y >= 0:
		return true
	return false

func enter(_prev_state: String) -> void:
	player.timers.get_node("coiling_time").start()
	player.coiling_collision_shape.disabled = false
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true

func exit(_next_state: String) -> void:
	coiling = true
	player.timers.get_node("coiling_time").stop()
	player.coiling_collision_shape.disabled = true
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true

func move_player():
	super.move_player()
