extends Node


const CHATBOX_UI_PATH = "/root/Game/Chatbox"

func send_chat_message(user: String, message: String, user_color="red", message_color="black", local_only=false):
	if local_only:
		get_node(CHATBOX_UI_PATH).new_chat_message(user, message, user_color, message_color)
	else:
		get_node(CHATBOX_UI_PATH).new_chat_message.rpc(user, message, user_color, message_color)
