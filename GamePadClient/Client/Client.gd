extends TextureRect

const SERVER_PORT = 31416
const MAX_PLAYERS = 4

var ip_adress = '192.168.86.43'
var _id = null
var connected = false


func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "on_connected_to_server")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "on_connection_failed")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "on_server_disconnected")
	
	join_server()


func join_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip_adress, SERVER_PORT)
	get_tree().set_network_peer(host)


func quit_game():
	get_tree().set_network_peer(null)


func on_connected_to_server():
	connected = true

func on_connection_failed():
	print('connection failure')

func on_server_disconnected():
	print('disconnected from server')


func _on_Dpad_direction_pressed(direction):
	if connected:
		rpc_unreliable_id(1, 'key_pressed', direction)

func _on_Dpad_direction_released(direction):
	if connected:
		rpc_unreliable_id(1, 'key_released', direction)


func _on_Button_button_pressed(button):
	if connected:
		rpc_unreliable_id(1, 'key_pressed', button)

func _on_Button_button_released(button):
	if connected:
		rpc_unreliable_id(1, 'key_released', button)
