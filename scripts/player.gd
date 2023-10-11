extends CharacterBody3D

#Nodes

@onready var head = $head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var top_of_head = $raycasts/top_of_head

#Config vars
const mouse_sensitivity: float = 0.2
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Player stats
const crouching_speed: float = 3.0
const walking_speed: float = 5.0
const sprinting_speed: float = 8.0
const jump_velocity: float = 4.5
const sliding_minimum_velocity: float = 7.0

#Mouvement vars
var current_speed: float = 5.0
var crouching_depth: float = 0.5
var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

#Player state
var is_running: bool = false
var is_sprinting: bool = false
var is_crouching: bool = false
var is_sliding: bool = false

var input_dir
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func running():
	is_running = true
	current_speed = sprinting_speed

func crouching(delta):
	is_crouching = true
	current_speed = crouching_speed
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false
	head.position.y = lerp(head.position.y, crouching_depth, lerp_speed * delta)
	
func sliding():
	pass

func walking():
	current_speed = walking_speed

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_pressed("crouch") and is_on_floor():
		crouching(delta)
	elif not top_of_head.is_colliding():
		head.position.y = lerp(head.position.y, 1.8, lerp_speed * delta)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		if Input.is_action_pressed("sprint") and is_on_floor():
			running()
		else:
			walking()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), lerp_speed * delta)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	move_and_slide()
