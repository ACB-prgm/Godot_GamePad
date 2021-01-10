extends Control


func _on_StartServerButton_pressed():
	Server.start_server()
	UdpBroadcast.start_broadcast()


func _on_StopServerButton_pressed():
	Server.stop_server()
	UdpBroadcast.stop_broadcast()


remote func _on_button_pressed(side, button):
	var id = get_tree().get_rpc_sender_id()
	var current_player = Server.clients[id]
	current_player.set(button, true)

remote func _on_button_released(side, button):
	var id = get_tree().get_rpc_sender_id()
	var current_player = Server.clients[id]
	current_player.set(button, false)


remote func _on_input_direction_calculated(side, direction, intensity):
	var id = get_tree().get_rpc_sender_id()
	var current_player = Server.clients[id]
	current_player.input_vector = direction

