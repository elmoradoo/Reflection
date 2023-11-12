extends Node


const UI_BASE_PATH: String = "/root/Game/"
@export var IS_FOCUSED: bool = false

func _show_ui(ui_name: String):
	var node = get_node(UI_BASE_PATH + ui_name)
	node.show()
	return node

func _hide_ui(ui_name: String):
	var node =  get_node(UI_BASE_PATH + ui_name)
	node.hide()
	return node

func _toggle(ui_name: String, show=false):
	if show:
		return _show_ui(ui_name)
	else:
		return _hide_ui(ui_name)

func chatbox(show=false):
	_toggle("Chatbox", show)

func multiplayer(show=false):
	_toggle("MultiplayerMenu", show)

func hud(show=false):
	var hud_node = _toggle("HUD", show)
	if GameVars.PLAYER_NODE:
		if show:
			GameVars.PLAYER_NODE.stats_update.connect(hud_node._on_stats_update)
		else:
			GameVars.PLAYER_NODE.stats_update.disconnect(hud_node._on_stats_update)

func main(show=false):
	_toggle("MainMenu", show)
