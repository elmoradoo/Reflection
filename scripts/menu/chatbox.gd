extends Node


@rpc("any_peer", "call_local", "unreliable")
func new_chat_message(user: String, message: String):
	$Container/ChatHistory.text += user + ": " + message

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_text_newline"):
		var message = $Container/SendMessage.text
		if message:
			new_chat_message.rpc(str(multiplayer.multiplayer_peer.get_unique_id()), message)
			$Container/SendMessage.clear()
			$Container/SendMessage.release_focus()
		else:
			$Container/SendMessage.grab_focus()
