extends Object

var myself
#Nodes
var neck
var head
var standing_collision_shape
var crouching_collision_shape
var transform


var velocity: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var delta
var current_speed: float = 0.0

var event
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var free_looking: bool = false
const mouse_sensitivity: float = 0.2
var input_dir: Vector2 = Vector2.ZERO

func init(se, indir):
	#Nodes and references
	myself = se
	self.velocity = myself.velocity
	self.direction = myself.direction
	self.standing_collision_shape = myself.standing_collision_shape
	self.crouching_collision_shape= myself.crouching_collision_shape
	self.neck = myself.neck
	self.head = myself.head
	self.transform = myself.transform
	self.input_dir = indir

func update(del):
	self.delta = del

func update_event(e):
	event = e
