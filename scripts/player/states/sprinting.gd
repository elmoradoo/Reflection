extends State


@export var max_speed: float = 8.0
@export var acceleration: float = 3.0
@export var minimum_velocity: float = 5.0

var pressed_rotate: bool = false


func can_enter(_prev_state: String):
	return player.is_on_floor() and player.input_dir != Vector2.ZERO

func enter(_prev_state: String) -> void:
	pass

func move_player():
	player.stand_up()
	player.head_bob(0.2, 22.0 + acceleration)
	var target_velocity = (player.transform.basis * Vector3(player.input_dir.x, 0, player.input_dir.y)).normalized() * max_speed

	# Running backwards
	if player.input_dir.y > 0 or (player.input_dir.x != 0 and player.input_dir.y == 0):
		target_velocity /= 1.5

	player.velocity = player.velocity.lerp(target_velocity, acceleration * player.delta)
	var acceleration_normalized = player.velocity.length() / max_speed
	super.move_player()

func exit(next_state: String) -> void:
	if next_state == "AirTime":
		player.model_anim.play("basic/fall")

func check_input_next_state():
	super.check_input_next_state()
	if Input.is_action_just_pressed("rotate") and not pressed_rotate:
		pressed_rotate = true
		player.smooth_rotate(PI, 15.0)
	elif not player.is_rotating:
		pressed_rotate = false
