extends Control

const SERVER_PORT = 31416
const MAX_PLAYERS = 4

var ip_adress = '192.168.1.132'
#var ip_adress = '127.0.0.1'
var _id = null
var connected = false


func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "on_connected_to_server")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "on_connection_failed")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "on_server_disconnected")


func join_server():
	var host = NetworkedMultiplayerENet.new()
	var ERR = host.create_client(ip_adress, SERVER_PORT)
	get_tree().set_network_peer(host)

	if ERR == OK:
		return true
	else:
		return false


func quit_game():
	get_tree().set_network_peer(null)


func on_connected_to_server():
	connected = true

func on_connection_failed():
	print('connection failure')

func on_server_disconnected():
	print('disconnected from server')
