extends Control


func _on_StartServerButton_pressed():
	Server.start_server()
	UdpBroadcast.start_broadcast()


func _on_StopServerButton_pressed():
	Server.stop_server()
	UdpBroadcast.stop_broadcast()


remote func key_pressed(key):
	var id = get_tree().get_rpc_sender_id()
	var current_player = Server.clients[id]
	current_player.set(key, true)

remote func key_released(key):
	var id = get_tree().get_rpc_sender_id()
	var current_player = Server.clients[id]
	current_player.set(key, false)


remote func direction_calculated(direction):
	var id = get_tree().get_rpc_sender_id()
	var current_player = Server.clients[id]
	current_player.input_vector = direction

