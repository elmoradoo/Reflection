extends State


var vault_timer_end: bool = false
var old_vel: Vector3 = Vector3.ZERO
var vault_speed: float = 2.0


func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("vault_time").timeout.connect(vault_time)

func enter():
	player.timers.get_node("vault_time").start()
	old_vel = player.velocity
	player.velocity = Vector3.ZERO
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = false
	player.model.get_node("AnimationPlayer").play("basic/vault")

func vault_time():
	vault_timer_end = true

func move_player():
	if vault_timer_end:
		player.position.y = lerp(player.position.y, 0.0, vault_speed * player.delta)
		player.velocity.x = clamp(old_vel.x, 0.0, vault_speed)
		player.velocity.z = clamp(old_vel.z, 0.0, vault_speed)
	else:
		player.position.y = lerp(player.position.y, player.position.y + 1.0, vault_speed * player.delta)
		var forward = player.transform.basis.z.normalized()
		player.position.x = lerp(player.position.x, player.position.x + (-forward.x * 4.0), vault_speed * player.delta)
		player.position.z = lerp(player.position.z, player.position.z + (-forward.z * 4.0), vault_speed * player.delta)
	super.move_player()

func exit():
	vault_timer_end = false
	player.timers.get_node("vault_time").stop()
	player.coiling_collision_shape.disabled = true
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = false
	player.velocity = old_vel
	player.velocity.y = 0.0

func check_physics_next_state():
	if not vault_timer_end:
		return
	if player.is_on_floor():
		if player.velocity.length() >= 2:
			change_state.emit("Sprinting")
		else:
			change_state.emit("Idle")
	elif not player.rc_feets.get_node("down").is_colliding():
		change_state.emit("AirTime")
