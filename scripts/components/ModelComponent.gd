extends Node3D

@export var loaded_model: PackedScene = null
var default_model: PackedScene = preload("res://assets/player/default/defaultx.tscn")
var model_instance = null

func init():
	print(loaded_model)
	if loaded_model == null:
		model_instance = default_model.instantiate()
	else:
		model_instance = loaded_model.instantiate()
	add_child(model_instance)

func switch_model():
	pass
