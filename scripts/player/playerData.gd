class_name playerData extends Object

var myself

#Config
var enums = preload("res://scripts/player/enums.gd")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const mouse_sensitivity: float = 0.2

var event

#Nodes
var neck: Node3D
var head: Node3D
var eyes: Node3D
var animation_player: AnimationPlayer
var standing_collision_shape: CollisionShape3D
var crouching_collision_shape: CollisionShape3D
var raycasts: Node3D
var transform
var timers: Node

#Raycasts groups
var rc_feets : Node3D
var rc_head : Node3D

#Movement
var velocity: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var delta
var current_speed: float = 0.0

var sliding_minimum_velocity: float = 5.0

#Player state
var current_state = enums.player_states.Idle

var input_dir: Vector2 = Vector2.ZERO



func init(se, rays):
	#Nodes and references
	myself = se
	self.velocity = myself.velocity
	self.direction = myself.direction
	self.standing_collision_shape = myself.standing_collision_shape
	self.crouching_collision_shape= myself.crouching_collision_shape
	self.neck = myself.neck
	self.head = myself.head
	self.eyes = myself.eyes
	self.transform = myself.transform
	self.raycasts = rays
	self.rc_feets = self.raycasts.get_node("feets")
	self.rc_head = self.raycasts.get_node("head")
	self.animation_player = myself.animation_player
	self.timers = myself.timers
	#print(self.timers.get_node("wallclimb_time"))

func update(del):
	self.delta = del
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	velocity.y -= gravity * delta

func update_event(e):
	event = e
