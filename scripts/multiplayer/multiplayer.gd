# multiplayer.gd
extends Node

const PORT = 25565

func _ready():
	multiplayer.server_relay = false

func _on_host_pressed():
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	print("Started server")
	start_game()


func _on_connect_pressed():
	# Start as client.
	var txt : String = $UI/Net/Options/Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()

# The server can restart the level by pressing Home.
func _input(event):
	if not multiplayer.is_server():
		return
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
	print("Spawned player " + str(id) + str(multiplayer.is_server()))

func start_game():
	# Hide the UI and unpause to start the game.
	$UI.hide()
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(spawn_player)
		change_level.call_deferred(load("res://scenes/world.tscn"))
		spawn_all_players.call_deferred()
