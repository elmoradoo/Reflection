extends Node


func send_chat_message(user: String, message: String, local_only=false):
	if local_only:
		get_node("/root/UI/Chatbox").new_chat_message(user, message)
	else:
		get_node("/root/UI/Chatbox").new_chat_message.rpc(user, message)
