extends Node3D

@export var loaded_model: PackedScene = null
var default_model: PackedScene = preload("res://assets/player/default/defaultx.tscn")
var model_instance = null
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playery = $playery
var current_state = null : set = _set_state

#TMP
const SprintingScript = preload("res://scripts/player/animations/sprinting_anim.gd")
var sprintingAnim = SprintingScript.new()

func init():
	var num_children = get_child_count()
	if loaded_model != null:
		model_instance = loaded_model.instantiate()
		remove_child($defaulty)
		add_child(model_instance)
	sprintingAnim.init(animation_tree)


func switch_model():
	pass
	
func _physics_process(delta):
	if current_state != "Sprinting":
		return
	sprintingAnim.run_animation(delta)

func _set_state(new_state):
	current_state = new_state
