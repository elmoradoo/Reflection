extends State


var velocity_before_landing: Vector3
var collided: bool = false

func _on_collision(previous_vel: Vector3, new_collision: KinematicCollision3D):
	super._on_collision(previous_vel, new_collision)
	collided = true

func can_enter(prev_state: String) -> bool:
	if prev_state == "Vault":
		return not player.rc_feets.get_node("down").is_colliding()
	return not player.is_on_floor()

func enter(_prev_state: String) -> void:
	velocity_before_landing = player.velocity
	player.model.get_node("AnimationPlayer").queue("basic/fall")

func exit(_next_state: String) -> void:
	player.animation_player.play("land")
	collided = false

func move_player():
	player.reset_head_bob()
	velocity_before_landing = player.velocity
	super.move_player()
