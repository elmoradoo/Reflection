extends BaseState


const max_speed: float = 8.0
#var lerp_speed: float = 0.5
var acceleration = 5.0

var enums = preload("res://scripts/player/enums.gd")

func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.Sprinting

func enter():
	player.model.get_node("AnimationPlayer").play("running")

func update():
	super.stand_up()
	super.head_bob(0.2)
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	
func exit():
	pass

func update_event(event: InputEvent):
	super.update_event(event)
	if event is InputEventKey:
		if event.is_action_pressed("crouch") and player.is_on_floor():
			if player.velocity.length() >= sliding_minimum_velocity:
				return enums.player_states.Sliding
			else:
				return enums.player_states.Crouching
		elif event.is_action_pressed("jump") and player.is_on_floor():
			return enums.player_states.Jumping

func get_next_state():
	if player.is_on_floor():
		if player.input_dir == Vector2.ZERO:
			return enums.player_states.Idle
		return enums.player_states.Sprinting
	else:
		return enums.player_states.AirTime
