extends Object


#Nodes
var neck
var head
var standing_collision_shape
var crouching_collision_shape


var velocity: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var delta
var current_speed: float = 0.0
var free_looking: bool = false


func init(velocity, direction, neck, head, scs, ccs):
	self.velocity = velocity
	self.direction = direction
	self.neck = neck
	self.head = head
	self.standing_collision_shape = scs
	self.crouching_collision_shape= ccs

func update(delta):
	self.delta = delta
	# Update player state variables
