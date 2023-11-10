extends Node


func _on_new_game_pressed():
	$"..".change_menu(null)
	get_tree().root.add_child(load("res://scenes/world.tscn").instantiate())
	get_tree().root.add_child(load("res://scenes/player.tscn").instantiate())

func _on_multiplayer_pressed():
	$"..".change_menu($"../MultiplayerMenu")
	var multiplayer_scene = load("res://scenes/multiplayer.tscn").instantiate()
	multiplayer_scene.name = "MultiplayerScene"
	get_tree().root.add_child(multiplayer_scene)
