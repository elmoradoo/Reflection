extends Node


func _input(event):
	# The server can restart the level by pressing Home.
	if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		change_level.call_deferred(load("res://scenes/world.tscn"))
		spawn_all_players.call_deferred()

func change_level(scene: PackedScene):
	var level = scene.instantiate()
	# Remove previous level
	for child in $Level.get_children():
		$Level.remove_child(child)
		child.queue_free()
	# Load new level
	$Level.add_child(level)

func spawn_all_players():
	# Remove previous players, if any
	for child in $Players.get_children():
		$Players.remove_child(child)
		child.queue_free()

	for player_id in multiplayer.get_peers():
		spawn_player(player_id)
	spawn_player(multiplayer.multiplayer_peer.get_unique_id())

func spawn_player(id: int):
	var player = load("res://scenes/player.tscn").instantiate()
	player.name = str(id)
	$Players.add_child(player)

func despawn_player(id: int):
	var player = get_node(str($Players.get_path()) + "/" + str(id))
	$Players.remove_child(player)
	player.queue_free()

func host_lobby():
	start_game()

func start_game():
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	multiplayer.peer_disconnected.connect(despawn_player, CONNECT_DEFERRED)
	multiplayer.peer_connected.connect(spawn_player, CONNECT_DEFERRED)
	change_level.call_deferred(load("res://scenes/world.tscn"))
	spawn_all_players.call_deferred()
