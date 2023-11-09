# multiplayer.gd
extends Node

const PORT = 7000

func _ready():
	if not multiplayer.is_server():
		return

	# Start paused.
	#get_tree().paused = true
	# You can save bandwidth by disabling server relay and peer notifications.
	multiplayer.server_relay = false

	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()

	multiplayer.peer_connected.connect(spawn_player)

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
		change_level(load("res://scenes/world.tscn"))
		spawn_peer_players()
		if not OS.has_feature("dedicated_server"):
			spawn_player(1)

func remove_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func change_level(scene: PackedScene):
	# Remove old level if any
	var spawner = $LevelSpawner
	remove_children(spawner)
	# Load new level
	spawner.add_child(scene.instantiate())

func spawn_peer_players():
	for player_id in multiplayer.get_peers():
		spawn_player(player_id)

func spawn_player(id: int):
	var loaded_level = $LevelSpawner.get_child(0)
	if not loaded_level:
		print_debug("Level not yet loaded.")
		return
	for child in loaded_level.get_children():
		if child.name == str(id):
			print_debug("Player " + str(id) + " already spawned.")
			return

	var player = load("res://scenes/player.tscn").instantiate()
	player.name = str(id)
	loaded_level.add_child(player)
	print("Spawned player " + str(id))

func start_game():
	# Hide the UI and unpause to start the game.
	$UI.hide()
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level(load("res://scenes/world.tscn"))
		if not OS.has_feature("dedicated_server"):
			spawn_player(1)
