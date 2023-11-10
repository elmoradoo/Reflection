extends Node


func join_lobby():
	multiplayer.server_disconnected.connect(server_disconnected)

func server_disconnected():
	OS.alert("Server disconnected.")
