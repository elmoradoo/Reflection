extends Node


const UI_BASE_PATH: String = "/root/Game/"


func _show_ui(ui_name: String):
	get_node(UI_BASE_PATH + ui_name).show()

func _hide_ui(ui_name: String):
	get_node(UI_BASE_PATH + ui_name).hide()

func _toggle(ui_name: String, show=false):
	if show:
		_show_ui(ui_name)
	else:
		_hide_ui(ui_name)

func chatbox(show=false):
	_toggle("Chatbox", show)

func multiplayer(show=false):
	_toggle("MultiplayerMenu", show)

func main(show=false):
	_toggle("MainMenu", show)
