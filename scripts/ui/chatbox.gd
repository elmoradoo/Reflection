extends Control


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

# This allows us to grab the enter key ONLY when SendMessage is not focussed yet.
func _unhandled_key_input(event):
	if event.is_action_pressed("ui_text_newline"):
		$Container/SendMessage.grab_focus()
		UI.IS_FOCUSED = true

# SendMessage captures all enter key inputs when focussed,
# so here we use _input instead to override that.
func _input(event):
	if event.is_action_pressed("ui_text_newline"):
		if $Container/SendMessage.has_focus():
			var message = $Container/SendMessage.text
			if message:
				if message != "\n":
					var username = str(multiplayer.multiplayer_peer.get_unique_id())
					new_chat_message.rpc(username, message + str("\n"), "blue")
				$Container/SendMessage.clear()
				$Container/SendMessage.release_focus()
				UI.IS_FOCUSED = false
				# Without accept_event, SendMessage will grab the enter key input

				accept_event()


func _on_send_message_focus_entered():
	$Container/ChatHistory/Panel.modulate.a = HISTORY_FOCUS_TRANSPARENCY
	$Container/SendMessage.modulate.a = SEND_FOCUS_TRANSPARENCY

func _on_send_message_focus_exited():
	$Container/ChatHistory/Panel.modulate.a = HISTORY_UNFOCUS_TRANSPARENCY
	$Container/SendMessage.modulate.a = SEND_UNFOCUS_TRANSPARENCY
