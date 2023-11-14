extends Node


# LEVEL
var LEVEL_SCENE: String = "res://scenes/level/world.tscn"
var LEVEL_ZERO: String = "res://scenes/level/prefabTests.tscn"
var LEVEL_NODE: Node = null

# PLAYER
var PLAYER_STATE_ENUM: String = "res://scripts/player/enums.gd"
var PLAYER_SCENE: String = "res://scenes/player/player.tscn"
var PLAYER_NODE: Node = null

# MULTIPLAYER
var MULTIPLAYER_SCENE: String = "res://scenes/network/multiplayer.tscn"
var MULTIPLAYER_SERVER_SCRIPT: String = "res://scripts/multiplayer/server.gd"
var MULTIPLAYER_CLIENT_SCRIPT: String = "res://scripts/multiplayer/client.gd"
var MULTIPLAYER_LEVEL_SPAWNER: String = "/root/Multiplayer/LevelSpawner"
var MULTIPLAYER_PLAYER_SPAWNER: String = "/root/Multiplayer/PlayerSpawner"
var MULTIPLAYER_SCENE_NODE: Node = null
