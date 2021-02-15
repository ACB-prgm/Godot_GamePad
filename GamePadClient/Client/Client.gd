extends Control

const SERVER_PORT = 31416
const MAX_PLAYERS = 4

#var ip_address = '192.168.1.208'
var host_ip_address = null
var _id = null
var connected = false
var layout_dict = {}


func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "on_connected_to_server")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "on_connection_failed")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "on_server_disconnected")


func join_server():
	if host_ip_address:
		var host = NetworkedMultiplayerENet.new()
		var ERR = host.create_client(host_ip_address, SERVER_PORT)
		get_tree().set_network_peer(host)

		if ERR == OK:
			return true
		else:
			return false
	else:
		print('No Host IP Adress')


func quit_game():
	get_tree().set_network_peer(null)


func on_connected_to_server():
	print('Connected To Server')
	connected = true


func on_connection_failed():
	print('connection failure')


func on_server_disconnected():
	print('Disconnected From Server')
	connected = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://JoinServer/JoinServerControl.tscn")
