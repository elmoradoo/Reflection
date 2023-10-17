extends Node

var player
var lerp_speed = 10.0

func init(obj):
	player = obj

func enter(obj):
	player = obj

func update():
	player.free_looking = false
	player.neck.rotation.y = lerp(player.neck.rotation.y, 0.0, player.delta * lerp_speed) # ICI 0.0
	player.head.position.y = 0.0
	#head.position.y = lerp(head.position.y, 0.0, lerp_speed * delta)
	player.standing_collision_shape.disabled = false
	player.crouching_collision_shape.disabled = true
	player.velocity.x = move_toward(player.velocity.x, 0, player.current_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.current_speed)
	
func exit():
	pass
