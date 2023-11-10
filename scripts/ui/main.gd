extends Node


func _on_new_game_pressed():
	UI.main(false)
	get_tree().root.add_child(load(GameVars.LEVEL_SCENE).instantiate())
	get_tree().root.add_child(load(GameVars.PLAYER_SCENE).instantiate())

func _on_multiplayer_pressed():
	UI.main(false)
	UI.multiplayer(true)
