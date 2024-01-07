extends Node

var animation_tree: AnimationTree
var param01 = "parameters/Running/a/blend_amount"
var param02 = "parameters/Running/b/blend_amount"
var param03 = "parameters/Running/c/blend_amount"

var blending_speed: float  = 5.0
var blending: float = 0.0
var blending_direction: float = 1

var animation_sequence = ["a", "b", "c", "A", "b", "C"]
var sequence_index = 0
var path = "abcabc"
var current = 0
var state_machine

func init(anim):
	animation_tree = anim
	state_machine = animation_tree["parameters/playback"]

func flip_blending(path):
	if animation_tree.get(path) == 0.0:
		animation_tree.set(path, 1.0)
	else:
		animation_tree.set(path, 0.0)

func get_next_blend_value(delta):
	blending += blending_direction * delta * blending_speed
	blending = clamp(blending, 0.0, 1.0)

func get_path_from_letter(letter):
	if letter == "a" or letter == "A":
		return param01
	if letter == "b" or letter == "B":
		return param02
	if letter == "c" or letter == "C":
		return param03

func blending_is_over(current):
	if current == 1.0 and blending_direction == 1:
		return true
	if current == 0.0 and blending_direction == -1:
		return true
	return false


func update_blending():
	if animation_tree.get(get_path_from_letter(path[current])) == 0.0:
		blending_direction = 1
		blending = 0.0
	else:
		blending_direction = -1
		blending = 1.0

func update_sequence_index() -> void:
	sequence_index += 1
	if sequence_index >= animation_sequence.size():
		sequence_index = 0
	update_blending_direction()

func update_blending_direction() -> void:
	var current_letter: String = animation_sequence[sequence_index]
	var current_path: String = get_path_from_letter(current_letter)
	if animation_tree.get(current_path) == 0.0:
		blending_direction = 1
		blending = 0.0
	else:
		blending_direction = -1
		blending = 1.0

func run_animation(delta):
	state_machine.travel("BlendTreet")
	return
	var current_letter: String = animation_sequence[sequence_index]
	var current_path: String = get_path_from_letter(current_letter)
	match current_letter:
		"a", "b", "c":
			get_next_blend_value(delta)
			animation_tree.set(current_path, blending)
		"A", "B", "C":
			flip_blending(current_path)
	if blending_is_over(animation_tree.get(current_path)):
		update_sequence_index()
