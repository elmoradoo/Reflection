extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/new_game_button.pressed.connect(self.new_game)
	$VBoxContainer/multiplayer_button.pressed.connect(self.multi)

func new_game():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	get_tree().root.add_child(load("res://scenes/player.tscn").instantiate())

func multi():
	get_tree().change_scene_to_file("res://scenes/multiplayer.tscn")
