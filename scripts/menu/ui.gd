extends Node

@onready var current_menu: MarginContainer = $MainMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/VBoxContainer/NewGame.pressed.connect(self.new_game)
	$MainMenu/VBoxContainer/Multiplayer.pressed.connect(self.multi)

func change_menu(new_menu: MarginContainer):
	current_menu.hide()
	if new_menu:
		new_menu.show()
		current_menu = new_menu

# Main menu
func new_game():
	change_menu(null)
	get_tree().root.add_child(load("res://scenes/world.tscn").instantiate())
	get_tree().root.add_child(load("res://scenes/player.tscn").instantiate())

func multi():
	change_menu($MultiplayerMenu)
	var multiplayer_scene = load("res://scenes/multiplayer.tscn").instantiate()
	multiplayer_scene.name = "MultiplayerScene"
	get_tree().root.add_child(multiplayer_scene)

# Multiplayer menu
func _on_host_pressed():
	change_menu(null)
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server($MultiplayerMenu/Net/Options/Port.text.to_int())
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	get_node("/root/MultiplayerScene").start_game()


func _on_connect_pressed():
	change_menu(null)
	# Start as client.
	var txt : String = $MultiplayerMenu/Net/Options/Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, $MultiplayerMenu/Net/Options/Port.text.to_int())
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	get_node("/root/MultiplayerScene").start_game()
