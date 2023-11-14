extends Node

func _on_new_game_pressed():
	UI.main(false)
	GameVars.LEVEL_NODE = load(GameVars.LEVEL_SCENE).instantiate()
	get_tree().root.add_child(GameVars.LEVEL_NODE)
	GameVars.PLAYER_NODE = load(GameVars.PLAYER_SCENE).instantiate()
	get_tree().root.add_child(GameVars.PLAYER_NODE)
	UI.hud(true)

func _on_multiplayer_pressed():
	UI.main(false)
	UI.multiplayer(true)


func _on_level_0_pressed():
	UI.main(false)
	GameVars.LEVEL_NODE = load(GameVars.LEVEL_ZERO).instantiate()
	get_tree().root.add_child(GameVars.LEVEL_NODE)
	GameVars.PLAYER_NODE = load(GameVars.PLAYER_SCENE).instantiate()
	get_tree().root.add_child(GameVars.PLAYER_NODE)
	UI.hud(true)
