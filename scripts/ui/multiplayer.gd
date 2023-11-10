extends Node


func prepare_spawners():
	var level_spawner = get_node(GameVars.MULTIPLAYER_LEVEL_SPAWNER)
	level_spawner.add_spawnable_scene(GameVars.LEVEL_SCENE)
	var player_spawner = get_node(GameVars.MULTIPLAYER_PLAYER_SPAWNER)
	player_spawner.add_spawnable_scene(GameVars.PLAYER_SCENE)

func prepare_multiplayer(scene_script: String):
	GameVars.MULTIPLAYER_SCENE_NODE = load(GameVars.MULTIPLAYER_SCENE).instantiate()
	UI.multiplayer(false)
	UI.chatbox(true)
	get_tree().root.add_child(GameVars.MULTIPLAYER_SCENE_NODE)
	prepare_spawners()
	GameVars.MULTIPLAYER_SCENE_NODE.set_script(load(scene_script))
	GameVars.MULTIPLAYER_SCENE_NODE.set_process_input(true)

func _on_host_pressed():
	prepare_multiplayer(GameVars.MULTIPLAYER_SERVER_SCRIPT)
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server($Net/Options/Port.text.to_int())
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	GameVars.MULTIPLAYER_SCENE_NODE.host_lobby()

func _on_connect_pressed():
	prepare_multiplayer(GameVars.MULTIPLAYER_CLIENT_SCRIPT)
	# Start as client.
	var txt : String = $Net/Options/Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, $Net/Options/Port.text.to_int())
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	GameVars.MULTIPLAYER_SCENE_NODE.join_lobby()
