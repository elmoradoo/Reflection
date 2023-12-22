class_name Player extends CharacterBody3D

signal stats_update
signal line_update

#Shapecasts
@onready var vault_shapecasts = $vault_shapecasts


# Raycasts
@onready var raycasts: Node3D = $raycasts
@onready var rc_feets: Node3D = $raycasts/feets
@onready var rc_head: Node3D = $raycasts/head
@onready var rc_torso: Node3D = $raycasts/torso

# Timers
@onready var timers: Node3D = $timers

# Body
@onready var neck: Node3D = $neck
@onready var head: Node3D = $neck/head
@onready var eyes: Node3D = $neck/head/eyes
@onready var camera: Camera3D = $neck/head/eyes/Camera3D

# Animations
@onready var model: Node3D = $player_model
@onready var animation_player: AnimationPlayer = $neck/head/eyes/AnimationPlayer

# Collisions
@onready var collision_shape: CollisionShape3D = $collision_shape

# State manager
@onready var player_state_manager: StateManager = $StateManager


#Movement
var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
const mouse_sensitivity: float = 0.2
var gravity_enabled: bool = true
@onready var delta: float = get_physics_process_delta_time()
var touched_floor: bool = true
var target_rotation: float = 0
var is_rotating: bool = false
var rotation_lerp: float = 0

func _enter_tree():
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())

func _on_get_stats_timeout():
	var DEBUG_ARRAY = [
	"Current State: " + player_state_manager.current_state.name,
	"Velocity: " + str(velocity.length()),
	"VelocityX: " + str(velocity.x),
	"VelocityY: " + str(velocity.y),
	"VelocityZ: " + str(velocity.z),
	"Inputs: " + str(input_dir),
	"FeetDownRC: " + str($raycasts/feets/down.is_colliding()),
	"IsOnFloor: " + str(is_on_floor()),
	"IsOnWall: " + str(is_on_wall()),
	"IsOnWallOnly: " + str(is_on_wall_only()),
	"Forward: " + str(transform.basis.z.normalized()),
	"FOV: " + str(int(camera.fov))
	]
	stats_update.emit(DEBUG_ARRAY)
	if velocity:
		var linelength = clamp(velocity.length()/2, 0, 10)
		var next_pos = global_transform.origin + velocity
		line_update.emit(next_pos, linelength)

func _ready():
	# Block controlling other players in multiplayer
	if not is_multiplayer_authority():
		self.set_process_input(false)
		self.set_process_unhandled_input(false)
		self.set_process_unhandled_key_input(false)
		self.set_physics_process(false)
		return

	# Activate camera
	$neck/head/eyes/Camera3D.current = true

	# Initialize state manager
	player_state_manager.init(self)

	# HUD update timer
	$timers/get_stats.start()


# This is only used for mouse events.
func _input(event):
	player_state_manager.update_event(event)


func _physics_process(physics_delta):
	delta = physics_delta
	player_state_manager.run()

func stand_up(lerp_speed=10.0):
	neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed)
	collision_shape.shape.height = lerp(collision_shape.shape.height, 2.0, lerp_speed * delta)
	#head.position.y = lerp(head.position.y, 0.0, lerp_speed * delta)

func stand_down(crouching_depth=-0.7, lerp_speed=10.0):
	collision_shape.shape.height = lerp(collision_shape.shape.height, 1.0, lerp_speed * delta)
	#head.position.y = lerp(head.position.y, crouching_depth, lerp_speed * delta)

func coil_legs(lerp_speed=10.0):
	collision_shape.shape.height = lerp(collision_shape.shape.height, 1.0, lerp_speed * delta)
	
func reset_neck(lerp_speed_local):
	neck.rotation.x = lerp(neck.rotation.x, 0.0, delta * lerp_speed_local)
	neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed_local)

@export_group("Head bobbing")
@export var head_bobbing_speed: float = 22.0
@export var head_bobbing_lerp: float = 10.0

func head_bob(intensity, bobbing_speed):
	return
	var head_bobbing_vector: Vector2 = Vector2.ZERO
	var head_bobbing_index: float = 0.0
	head_bobbing_index += bobbing_speed * delta
	head_bobbing_vector.y = sin(head_bobbing_index)
	head_bobbing_vector.x = sin(head_bobbing_index / 2) + 0.5
	eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y * (intensity / 2.0), delta * head_bobbing_lerp)
	eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x * intensity, delta * head_bobbing_lerp)

func reset_head_bob():
	eyes.position.y = lerp(eyes.position.y, 0.0, delta * head_bobbing_lerp)
	eyes.position.x = lerp(eyes.position.x, 0.0, delta * head_bobbing_lerp)


func smooth_rotate(angle: float, lerp_speed: float):
	if angle != 0:
		self.target_rotation = self.rotation.y + angle
		self.rotation_lerp = lerp_speed
		self.is_rotating = true
	elif self.is_rotating:
		if abs(angle_difference(self.target_rotation, self.rotation.y)) <= self.rotation_lerp * delta:
			self.is_rotating = false
			self.rotation.y = self.target_rotation
		else:
			self.rotation.y = lerp_angle(self.rotation.y, self.target_rotation, self.rotation_lerp * delta)
