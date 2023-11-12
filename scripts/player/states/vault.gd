extends BaseState


var is_fast_vault = false
var vault_timer_end = false
var old_vel
var old_pos

func init(obj):
	super.init(obj)
	player.timers.get_node("vault_time").timeout.connect(vault_time)
	
func enter():
	player.timers.get_node("vault_time").start()
	old_vel = player.velocity
	old_pos = player.position	
	player.velocity = Vector3.ZERO
	player.standing_collision_shape.disabled = true
	player.crouching_collision_shape.disabled = true
	player.coiling_collision_shape.disabled = false
	if player.velocity.y > 3:
		is_fast_vault = true

func vault_time():
	vault_timer_end = true

func climb_vault():
	pass
	
func fast_vault():
	player.velocity.y += 0.5

func move_player():
	if vault_timer_end:
		player.position.y = lerp(player.position.y, 0.0, 2.0 * player.delta)
		player.velocity.x = clamp(old_vel.x, 0.0, 2.0)
		player.velocity.z = clamp(old_vel.z, 0.0, 2.0)
	else:
		player.position.y = lerp(player.position.y, player.position.y + 1.0, 2.0 * player.delta)
		var forward = player.transform.basis.z.normalized()
		player.position.x = lerp(player.position.x, player.position.x + (-forward.x * 4.0), 2.0 * player.delta)
		player.position.z = lerp(player.position.z, player.position.z + (-forward.z * 4.0), 2.0 * player.delta)
	super.move_player()

func exit():
	vault_timer_end = false
	player.timers.get_node("vault_time").stop()
	player.coiling_collision_shape.disabled = true
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = false
	player.velocity = old_vel
	player.velocity.y = 0.0


func get_state_name(): 
	return enums.player_states.Vault

func get_physics_next_state():
	if not vault_timer_end:
		return enums.player_states.Vault 
	if player.is_on_floor():
		if player.velocity.length() >= 2:
			return enums.player_states.Sprinting
		else:
			return enums.player_states.Idle
	elif not player.rc_feets.get_node("down").is_colliding():
		return enums.player_states.AirTime		
	return enums.player_states.Vault  
