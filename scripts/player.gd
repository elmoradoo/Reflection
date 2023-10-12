extends CharacterBody3D

#Nodes
@onready var player = $"."
@onready var head = $neck/head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var top_of_head = $raycasts/top_of_head
@onready var neck = $neck
@onready var camera_3d = $neck/head/Camera3D
#Config vars
const mouse_sensitivity: float = 0.2
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Player states

enum player_states {
	Idle,
	Walking,
	Sprinting,
	Jumping,
	Crouching,
	Sliding
}

var current_state : player_states = player_states.Idle
#Player stats
const crouching_speed: float = 3.0
const walking_speed: float = 5.0
const sprinting_speed: float = 8.0
const jump_velocity: float = 4.5
const sliding_minimum_velocity: float = 7.0
const sliding_initial_force: float = 9.0
const sliding_friction: float = 4.0
#Mouvement vars
var current_speed: float = 5.0
var crouching_depth: float = -0.5
var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

#Player state
var is_running: bool = false
var is_sprinting: bool = false
var is_sliding: bool = false
var free_looking: bool = false

var input_dir
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		if free_looking:
			neck.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func sprinting():
	is_running = true
	current_speed = sprinting_speed

func crouching(delta):
	current_speed = crouching_speed
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false
	head.position.y = lerp(head.position.y, crouching_depth, lerp_speed * delta)
	
func sliding(delta):
	is_sliding = true
	free_looking = true
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false
	head.position.y = lerp(head.position.y, crouching_depth, lerp_speed * delta)
	var slide_force = direction.normalized() * sliding_initial_force
	velocity.x = slide_force.x
	velocity.z = slide_force.z
	velocity.x = move_toward(velocity.x, 0, sliding_friction * delta)
	velocity.z = move_toward(velocity.z, 0, sliding_friction * delta)

func walking():
	current_speed = walking_speed

func jumping():
	velocity.y = jump_velocity
	
func inputs_checks(delta):
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	if is_on_floor() and Input.is_action_pressed("crouch") and velocity.length() >= sliding_minimum_velocity:
		current_state = player_states.Sliding
	elif is_on_floor() and Input.is_action_pressed("crouch"):
		current_state = player_states.Crouching
	elif is_on_floor() and Input.is_action_just_released("crouch") and not top_of_head.is_colliding():
		print(free_looking)
		free_looking = false
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed) # ICI 0.0
		current_state = player_states.Idle
		head.position.y = 0.0
		#head.position.y = lerp(head.position.y, 0.0, lerp_speed * delta)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
	elif Input.is_action_pressed("sprint"):
		current_state = player_states.Sprinting
	else:
		current_state = player_states.Walking
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		current_state = player_states.Jumping



func _physics_process(delta):
	#Get state from inputs
	inputs_checks(delta)
	#Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	#Call state function
	match current_state:
		player_states.Idle:
			pass
		player_states.Walking:
			walking()
		player_states.Sprinting:
			sprinting()
		player_states.Jumping:
			jumping()
		player_states.Crouching:
			crouching(delta)
		player_states.Sliding:
			sliding(delta)

	#Calculate direction from inputs
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), lerp_speed * delta)
	
	#If direction is not vector zero 
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	#Decrease character speed if there is no input
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	if is_sliding and velocity.length() < 1.0:
		is_sliding = false
	current_state = player_states.Idle
	move_and_slide()
