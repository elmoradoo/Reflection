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

# Body
@onready var neck: Node3D = $neck
@onready var head: Node3D = $neck/head
@onready var eyes: Node3D = $neck/head/eyes
@onready var camera: Camera3D = $neck/head/eyes/Camera3D

# Animations
@onready var animation_player: AnimationPlayer = $neck/head/eyes/AnimationPlayer
@onready var model_anim = $AnimationPlayer

# Collisions
@onready var collision_shape: CollisionShape3D = $collision_shape

# State manager
@onready var player_state_manager: StateManager = $StateManager

@onready var model_component = $ModelComponent

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

var raycasts_left: Array[RayCast3D] = []
var raycasts_right: Array[RayCast3D] = []

@onready var standing_height: float = $collision_shape.shape.height

# Raycasts
# These height variables should always be between 0 and 1
@export_group("Height")
@export var feet_height: float = 0.1
@export var knees_height: float = 0.3
@export var waist_height: float = 0.5
@export var torso_height: float = 0.7
@export var shoulder_height: float = 0.8

func init_raycasts(num_raycasts):
	for i in range(num_raycasts):
		var raycast_left: RayCast3D = RayCast3D.new()
		var raycast_right: RayCast3D = RayCast3D.new()

		raycast_left.position.x = 0.5
		raycast_left.target_position = Vector3(0, 0, -1)
		raycast_left.enabled = true

		raycast_right.position.x = -0.5
		raycast_right.target_position = Vector3(0, 0, -1)
		raycast_right.enabled = true

		var height_offset: float = i * 0.1
		raycast_left.position.y = height_offset
		raycast_right.position.y = height_offset

		raycasts_left.append(raycast_left)
		raycasts_right.append(raycast_right)

		self.add_child(raycast_left)
		self.add_child(raycast_right)

func get_ledge_height(i: int = 0):
	var raycast_max: int = len(raycasts_left)
	while i < raycast_max and (raycasts_left[i].is_colliding() or raycasts_right[i].is_colliding()):
		i += 1
	if i == raycast_max:
		return 10000
	return i * 0.1

func get_roof_height():
	var i: int = get_ledge_height() * 10
	var raycast_max: int = len(raycasts_left)
	while i < raycast_max and not (raycasts_left[i].is_colliding() or not raycasts_right[i].is_colliding()):
		i += 1
	if i == raycast_max:
		return 10000
	return i * 0.1


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
	model_component.init()
	print(model_component.get_child(0))
	model_anim.root_node = model_component.get_child(0).get_path()

	# HUD update timer
	var hud_timer = Timer.new()
	hud_timer.timeout.connect(self._on_get_stats_timeout)
	add_child(hud_timer)
	hud_timer.start(0.1)

	# Raycasts
	self.init_raycasts(40)


# This is only used for mouse events.
func _input(event):
	player_state_manager.update_event(event)


func _physics_process(physics_delta):
	delta = physics_delta
	player_state_manager.run()

func stand_up(lerp_speed=10.0):
	neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed)
	collision_shape.shape.height = lerp(collision_shape.shape.height, standing_height, lerp_speed * delta)
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
