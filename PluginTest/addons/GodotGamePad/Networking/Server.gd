extends Node

const SERVER_PORT = 31416
const MAX_PLAYERS = 4

var ip_adress = '192.168.0.1'
var clients = {}
var server_exists = false


func _ready():
	# gets the IP address of this device and sets this server's IP to match
	for address in IP.get_local_addresses():
		if '192' in address:
			ip_adress = address
			break
	
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "on_network_peer_connected")
	get_tree().connect("network_peer_connected", GamePad, "_on_Server_network_peer_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "on_network_peer_disconnected")
	get_tree().connect("network_peer_disconnected", GamePad, "_on_Server_network_peer_disconnected")


func start_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)
	allow_connections()
	
	server_exists = true


func stop_server():
	disallow_connections()
	get_tree().set_network_peer(null)
	for id in clients.keys():
		clients[id].queue_free()
	clients.clear()
	
	server_exists = false


func allow_connections():
	get_tree().set_refuse_new_network_connections(false)

func disallow_connections():
	get_tree().set_refuse_new_network_connections(true)


func on_network_peer_connected(id):
#	print('client %s connected!' % id)
	register_client(id)


func register_client(id):
#	var playerINS = player.instance()
#	self.add_child(playerINS)
#	clients[id] = playerINS
	print("client %s registered" %id)


func on_network_peer_disconnected(id):
	print('client %s disconnected' % id)
#	clients[id].queue_free()
#	clients.erase(id)
