extends Node


func _on_host_pressed():
	$"..".change_menu(null)
	$"../Chatbox".show()
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server($Net/Options/Port.text.to_int())
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	get_node("/root/MultiplayerScene").host_lobby()

func _on_connect_pressed():
	$"..".change_menu(null)
	$"../Chatbox".show()
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
	get_node("/root/MultiplayerScene").join_lobby()
