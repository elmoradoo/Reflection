extends CharacterBody3D

#Config vars
const mouse_sensitivity: float = 0.2

# Player object that have all of the player and associated variable
var player_data_object = preload("res://scripts/player/playerData.gd")
var player_object

#State scripts
var idle_ss = preload("res://scripts/player/states/idle.gd")
var walking_ss = preload("res://scripts/player/states/walking.gd")
var sprinting_ss = preload("res://scripts/player/states/sprinting.gd")
var crouching_ss = preload("res://scripts/player/states/crouching.gd")
var sliding_ss = preload("res://scripts/player/states/sliding.gd")
var jumping_ss = preload("res://scripts/player/states/jumping.gd")
var airtime_ss = preload("res://scripts/player/states/airtime.gd")

#And associated variables
var idle_state
var walking_state
var sprinting_state
var crouching_state
var sliding_state
var jumping_state
var airtime_state

#Nodes of the current scene
@onready var player = $"."
@onready var head = $neck/head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var top_of_head = $raycasts/top_of_head
@onready var neck = $neck
@onready var camera_3d = $neck/head/Camera3D

#Player states
enum player_states {
	Idle,
	Walking,
	Sprinting,
	Jumping,
	AirTime,
	Crouching,
	Sliding
}

var current_state : player_states = player_states.Idle

#Player stats
const sliding_minimum_velocity: float = 7.0

#Mouvement vars
var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

#Player state
var input_dir: Vector2 = Vector2.ZERO

func debug_print_player_state():
	print(input_dir)
	match current_state:
		player_states.Idle:
			print("idle")
		player_states.Walking:
			print("walking")
		player_states.Sprinting:
			print("sprinting")
		player_states.Jumping:
			print("jumping")
		player_states.Crouching:
			print("crouching")
		player_states.Sliding:
			print("sliding")
		player_states.AirTime:
			print("airtime")
	
func _ready():
	#Get mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#Instanciate state scripts
	idle_state = idle_ss.new()
	walking_state = walking_ss.new()
	sprinting_state = sprinting_ss.new()
	crouching_state = crouching_ss.new()
	sliding_state = sliding_ss.new()
	jumping_state = jumping_ss.new()
	airtime_state = airtime_ss.new()
	
	#Init player object
	player_object = player_data_object.new()
	player_object.init(self, input_dir)
	
	#Give player node to enter script
	idle_state.init(player_object)
	walking_state.init(player_object)
	sprinting_state.init(player_object)
	crouching_state.init(player_object)
	sliding_state.init(player_object)
	jumping_state.init(player_object)
	airtime_state.init(player_object)


func _input(event):
	player_object.update_event(event)

func inputs_checks(_delta):
	#Get player inputs
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	if is_on_floor():
		#If the player can slide
		if Input.is_action_pressed("crouch") and player_object.velocity.length() >= sliding_minimum_velocity:
			set_current_state(player_states.Sliding)
		#If the player is not sliding and press crouch
		elif Input.is_action_pressed("crouch") and current_state != player_states.Sliding:
			set_current_state(player_states.Crouching)
		#If the player release crouch and has clearance above his head
		elif Input.is_action_just_released("crouch") and not top_of_head.is_colliding():
			set_current_state(player_states.Idle)
		#If the player is not pressing anything
		elif input_dir == Vector2.ZERO and current_state != player_states.Crouching:
			set_current_state(player_states.Idle)
		#If the player is pressing sprint and moving
		elif Input.is_action_pressed("sprint") and input_dir != Vector2.ZERO and current_state:
			set_current_state(player_states.Sprinting)
		#If the player is walking
		elif input_dir != Vector2.ZERO:
			set_current_state(player_states.Walking)
		#If the player is pressing jump
		if Input.is_action_just_pressed("jump"):
			set_current_state(player_states.Jumping)
	else:
		set_current_state(player_states.AirTime)

func set_current_state(new_state):
	#Exit the current state
	match current_state:
		player_states.Idle:
			idle_state.exit()
		player_states.Walking:
			walking_state.exit()
		player_states.Sprinting:
			sprinting_state.exit()
		player_states.Jumping:
			jumping_state.exit()
		player_states.Crouching:
			crouching_state.exit()
		player_states.Sliding:
			sliding_state.exit()
	#Update current state
	current_state = new_state
	#Enter new state
	match current_state:
		player_states.Idle:
			idle_state.enter()
		player_states.Walking:
			walking_state.enter()
		player_states.Sprinting:
			sprinting_state.enter()
		player_states.Jumping:
			jumping_state.enter()
		player_states.Crouching:
			crouching_state.enter()
		player_states.Sliding:
			sliding_state.enter()
	
func _physics_process(delta):
	#Update player variables
	player_object.direction = direction
	player_object.velocity = velocity
	player_object.delta = delta
	player_object.transform = transform
	
	#Get state from inputs
	inputs_checks(delta)
	player_object.input_dir = input_dir

	debug_print_player_state()
	#Call state function
	match current_state:
		player_states.Idle:
			idle_state.update()
		player_states.Walking:
			walking_state.update()
		player_states.Sprinting:
			sprinting_state.update()
		player_states.Jumping:
			jumping_state.update()
		player_states.Crouching:
			crouching_state.update()
		player_states.Sliding:
			sliding_state.update()
		player_states.AirTime:
			airtime_state.update()
	velocity = player_object.velocity
	direction = player_object.direction
	move_and_slide()
