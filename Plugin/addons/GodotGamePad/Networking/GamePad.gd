extends Node

# SCRIPT
# This script contains both the functions to create and modify the server,
# aswell as the functions for recieving input from the GodotGamePad mobile app


# ——————————————— BUILT-IN FUNCTIONS (DO NOT MODIFY) ———————————————
# These functions should be called according to their definitions in order to 
# create and maintain a server to which the GodotGamePad mobile app will
# connect to.  Do not modify them unless you know what you are doing.

signal gamepad_connected(id)
signal gamepad_disconnected(id)


func _notification(what): # DO NOT MODIFY
	# Runs automatically when the game is quit to ensure that ports are closed
	# and the Server is shut down correctly
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		self.stop_server()
		self.get_tree().quit() # default behavior


func search_for_controllers(): # DO NOT MODIFY
	# Creates a Server that will host the connections to/from the GamePads
	# and begins a UDP Broadcast to search for any nearby GamePads which are 
	# searching for the host server. (An example would be to add a button to 
	# your lobby scene which says "search for controllers" which calls this 
	# function when pressed
	if !Server.server_exists: # Creates a new server if one does not exist
		Server.start_server()
	if !UdpBroadcast.is_broadcasting:
		UdpBroadcast.start_broadcast() # Begins searching for GamePads


func stop_search_for_controllers(): # DO NOT MODIFY
	# Should be called after all players are connected and play is about to begin
	if UdpBroadcast.is_broadcasting:
		UdpBroadcast.stop_broadcast() # Stops searching for GamePads


func stop_server(): # DO NOT MODIFY
	# Automatically called when the game is quit, but you may call this if you 
	# want to create a new server for whatever reason or the game has been idle 
	# for too long.  It is entirely fine if this function is never used.
	if Server.server_exists:
		Server.stop_server()
		
	stop_search_for_controllers()


func _on_Server_network_peer_connected(id):
	# Emitted when a GamePad connects to the server.  The ID is a unique
	# identifier that corresponds to that mobile device.  This ID will be 
	# assigned when the GamePad connects, and thus will change if a GamePad
	# disconnects and re-connects
	emit_signal("gamepad_connected", id)


func _on_Server_network_peer_disconnected(id):
	# Emitted when a GamePad disconnects from the server.  The ID is a unique
	# identifier that corresponds to that mobile device.  This ID will be 
	# assigned when the GamePad connects, and thus will change if a GamePad
	# disconnects and re-connects
	emit_signal("gamepad_disconnected", id)
	

# ——————————————— GAMEPAD INPUT FUNCTIONS (MODIFY) ———————————————
# These functions will recieve the input from the GodotGamePad mobile app.
# DO NOT modify the function names or arguments, but you may modify the content
# to suit your needs.  Some default behavior is already there, and will most
# likely 

remote func _on_button_pressed(side, button):
	var id = get_tree().get_rpc_sender_id()
	print(button)
#	var current_player = Server.clients[id]
#	current_player.set(button, true)

remote func _on_button_released(side, button):
	var id = get_tree().get_rpc_sender_id()
#	var current_player = Server.clients[id]
#	current_player.set(button, false)


remote func _on_input_direction_calculated(side, direction, intensity):
	var id = get_tree().get_rpc_sender_id()
#	var current_player = Server.clients[id]
#	current_player.input_vector = direction

