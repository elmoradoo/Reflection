extends State


@export var vault_speed: float = 2.0


var vault_timer_end: bool = false
var old_vel: Vector3 = Vector3.ZERO

func init(player_obj: Player):
	super.init(player_obj)
	player.timers.get_node("vault_time").timeout.connect(vault_time)

func can_enter(_prev_state: String) -> bool:
	if player.rc_head.get_node("front").is_colliding():
		return false
	if player.vault_shapecasts.get_node("first").is_colliding():
		var normal = player.vault_shapecasts.get_node("first").get_collision_normal(0)
		var collision_second = player.vault_shapecasts.get_node("second").is_colliding()
		if normal.y == 1 and not collision_second:
			return true
	return false

func enter(_prev_state: String) -> void:
	player.timers.get_node("vault_time").start()
	old_vel = player.velocity
	player.velocity = Vector3.ZERO
	player.model.get_node("AnimationPlayer").play("basic/vault")
	

func vault_time():
	vault_timer_end = true

func move_player():
	player.coil_legs(20.0)
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

func exit(_next_state: String) -> void:
	vault_timer_end = false
	player.timers.get_node("vault_time").stop()
	player.velocity = old_vel
	player.velocity.y = 0.0

func check_physics_next_state():
	if not vault_timer_end:
		return
	super.check_physics_next_state()
