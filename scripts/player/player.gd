extends CharacterBody3D

#Config vars
const mouse_sensitivity: float = 0.2

#Game enums
var enums = preload("res://scripts/player/enums.gd")

#State manager
var player_state_manager_script = preload("res://scripts/player/states/player_state_manager.gd")
var player_state_manager

#Player object that have all of the player and associated variable
var player_data_object = preload("res://scripts/player/playerData.gd")
var player_object

#Nodes of the current scene
@onready var player = $"."
@onready var head = $neck/head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var top_of_head = $raycasts/top_of_head
@onready var neck = $neck
@onready var camera_3d = $neck/head/Camera3D

#Player states

var current_state = enums.player_states.Idle

#Player stats
const sliding_minimum_velocity: float = 7.0

#Mouvement vars
var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

#Player state
var input_dir: Vector2 = Vector2.ZERO

func _ready():
	#Get mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#Init player object
	player_object = player_data_object.new()
	player_object.init(self, input_dir)
	
	#Init script manager
	player_state_manager = player_state_manager_script.new()
	player_state_manager.init(player_object)
	

func _input(event):
	player_object.update_event(event)

#func inputs_checks(_delta):
#	#Get player inputs
#	input_dir = Input.get_vector("left", "right", "forward", "backward")
#	if is_on_floor():
#		#If the player can slide
#		if Input.is_action_pressed("crouch") and player_object.velocity.length() >= sliding_minimum_velocity:
#			set_current_state(enums.player_states.Sliding)
#		#If the player is not sliding and press crouch
#		elif Input.is_action_pressed("crouch") and current_state != enums.player_states.Sliding:
#			set_current_state(enums.player_states.Crouching)
#		#If the player release crouch and has clearance above his head
#		elif Input.is_action_just_released("crouch") and not top_of_head.is_colliding():
#			set_current_state(enums.player_states.Idle)
#		#If the player is not pressing anything
#		elif input_dir == Vector2.ZERO and current_state != enums.player_states.Crouching:
#			set_current_state(enums.player_states.Idle)
#		#If the player is pressing sprint and moving
#		elif Input.is_action_pressed("sprint") and input_dir != Vector2.ZERO:
#			set_current_state(enums.player_states.Sprinting)
#		#If the player is walking
#		elif input_dir != Vector2.ZERO:
#			set_current_state(enums.player_states.Walking)
#		#If the player is pressing jump
#		if Input.is_action_just_pressed("jump"):
#			set_current_state(enums.player_states.Jumping)
#	else:
#		set_current_state(enums.player_states.AirTime)

func _physics_process(delta):
	#Update player variables
	player_object.direction = direction
	player_object.velocity = velocity
	player_object.delta = delta
	player_object.transform = transform
	player_state_manager.run()
	velocity = player_object.velocity
	direction = player_object.direction
	move_and_slide()
