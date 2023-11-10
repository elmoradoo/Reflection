extends Node


var HISTORY_FOCUS_TRANSPARENCY: float = 1
var HISTORY_UNFOCUS_TRANSPARENCY: float = 0
var SEND_FOCUS_TRANSPARENCY: float = 1
var SEND_UNFOCUS_TRANSPARENCY: float = 0.5

func _ready():
	$Container/ChatHistory/Panel.modulate.a = HISTORY_UNFOCUS_TRANSPARENCY
	$Container/SendMessage.modulate.a = SEND_UNFOCUS_TRANSPARENCY

@rpc("any_peer", "call_local", "reliable")
func new_chat_message(user: String, message: String, user_color="red", message_color="lightsteelblue"):
	$Container/ChatHistory.text += "[b][color=" + user_color +"]" + user + "[/color][/b]" + ": " + "[color=" + message_color + "]" + message + "[/color]"

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_text_newline"):
		var message = $Container/SendMessage.text
		if message:
			if message != "\n":
				var username = str(multiplayer.multiplayer_peer.get_unique_id())
				new_chat_message.rpc(username, message, "blue")
			$Container/SendMessage.clear()
			$Container/SendMessage.release_focus()
		else:
			$Container/SendMessage.grab_focus()

func _on_send_message_focus_entered():
	$Container/ChatHistory/Panel.modulate.a = HISTORY_FOCUS_TRANSPARENCY
	$Container/SendMessage.modulate.a = SEND_FOCUS_TRANSPARENCY

func _on_send_message_focus_exited():
	$Container/ChatHistory/Panel.modulate.a = HISTORY_UNFOCUS_TRANSPARENCY
	$Container/SendMessage.modulate.a = SEND_UNFOCUS_TRANSPARENCY
