extends CharacterBody3D

#Game enums
var enums = preload("res://scripts/player/enums.gd")

#State manager
var player_state_manager_script = preload("res://scripts/player/player_state_manager.gd")
var player_state_manager

#Player object that have all of the player and associated variable
var player_data_object = preload("res://scripts/player/playerData.gd")
var player_object: playerData

#Nodes of the current scene
@onready var player = $"."
@onready var head = $neck/head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var coiling_collision_shape = $coiling_collision_shape
@onready var neck = $neck
@onready var camera_3d = $neck/head/eyes/Camera3D
@onready var eyes = $neck/head/eyes
@onready var animation_player = $neck/head/eyes/AnimationPlayer
@onready var raycasts = $raycasts
@onready var top_of_head = $raycasts/top_of_head
@onready var timers = $timers
@onready var wallclimb_time = $timers/wallclimb_time
@onready var player_model = $player_model

#Mouvement vars
var direction: Vector3 = Vector3.ZERO

func _enter_tree():
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	camera_3d.current = true

	#Get mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Init player object
	player_object = player_data_object.new()
	player_object.init(self, raycasts)
	#Init script manager
	player_state_manager = player_state_manager_script.new()
	player_state_manager.init(player_object)

func _input(event):
	if not is_multiplayer_authority(): return
	player_object.update_event(event)

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	#Update player variables
	player_object.direction = direction
	player_object.velocity = velocity
	player_object.delta = delta
	player_object.transform = transform
	player_object.update(delta)
	player_state_manager.run()
	velocity = player_object.velocity
	direction = player_object.direction
	move_and_slide()
