extends BaseState


const jump_velocity: float = 4.5
var enums = preload("res://scripts/player/enums.gd")


func get_state_name():
	return enums.player_states.Jumping

func enter():
	player.animation_player.play("jump")
	player.model.get_node("AnimationPlayer").play("jumping")

func update():

	#Set eyes to 0
	player.eyes.position.x = lerp(player.eyes.position.x, 0.0, player.delta * 1)
	player.eyes.position.y = lerp(player.eyes.position.x, 0.0, player.delta * 1)
	player.velocity.y += jump_velocity


func exit():
	pass

func get_next_state():
	if not player.is_on_floor():
		return enums.player_states.AirTime
	return enums.player_states.NULL
