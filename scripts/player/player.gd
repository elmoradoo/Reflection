class_name Player extends CharacterBody3D

signal stats_update
signal line_update

# Raycasts
@onready var raycasts = $raycasts
@onready var rc_feets = $raycasts/feets
@onready var rc_head = $raycasts/head
@onready var rc_torso = $raycasts/torso

# Timers
@onready var timers = $timers

# Body
@onready var neck = $neck
@onready var head = $neck/head
@onready var eyes = $neck/head/eyes

# Animations
@onready var model = $player_model
@onready var animation_player = $neck/head/eyes/AnimationPlayer

# Collisions
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var coiling_collision_shape = $coiling_collision_shape

# State manager
@onready var player_state_manager = load("res://scripts/player/player_state_manager.gd").new()


#Movement
var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const mouse_sensitivity: float = 0.2
var gravity_enabled: bool = true
@onready var delta = get_physics_process_delta_time()

func _enter_tree():
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())


func _on_get_stats_timeout():
	var DEBUG_ARRAY = [
	"Current State: " + str(player_state_manager.debug_get_player_state()),
	"Velocity: " + str(velocity.length()),
	"VelocityX: " + str(velocity.x),
	"VelocityY: " + str(velocity.y),
	"VelocityZ: " + str(velocity.z),
	"Inputs: " + str(input_dir),
	"FeetDownRC: " + str($raycasts/feets/down.is_colliding()),
	"WallClimbTimeLeft: " + str($timers/wallclimb_time.time_left),
	"IsOnFloor: " + str(is_on_floor()),
	"IsOnWall: " + str(is_on_wall()),
	]
	stats_update.emit(DEBUG_ARRAY)
	if velocity:
		var linelength = clamp(velocity.length()/2, 0, 10)
		var current_pos = global_transform.origin
		var next_pos = global_transform.origin + velocity
		line_update.emit(current_pos, next_pos, linelength)

func _ready():
	# Block controlling other players in multiplayer
	if not is_multiplayer_authority():
		self.set_process_input(false)
		self.set_process_unhandled_input(false)
		self.set_process_unhandled_key_input(false)
		self.set_physics_process(false)
		return

	$neck/head/eyes/Camera3D.current = true

	#Get mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Init player object
	#Init script manager
	player_state_manager.init(self)
	$timers/get_stats.start()

func _input(event):
	if event is InputEventMouseMotion:
		player_state_manager.update_event(event)

func _unhandled_key_input(event):
	if not UI.IS_FOCUSED:
		player_state_manager.update_event(event)

func _physics_process(physics_delta):
	delta = physics_delta
	move_and_slide()
	if gravity_enabled and not is_on_floor():
		velocity.y -= gravity * delta
	elif is_on_floor():
		velocity.y = 0
	player_state_manager.run()
