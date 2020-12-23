extends Control

const SERVER_PORT = 31416
const MAX_PLAYERS = 4

#var ip_adress = '127.0.0.1'
var ip_adress = '192.168.1.208'
var player = preload("res://Lobby/Player.tscn")
var clients = {}


func _ready():
	for address in IP.get_local_addresses():
		if '192' in address:
			ip_adress = address
			break
	
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "on_network_peer_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "on_network_peer_disconnected")


func start_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)
	print('Server Started')

func stop_server():
	get_tree().set_network_peer(null)
	clients.clear()
	print('server stopped and peers cleared')


func allow_connections():
	get_tree().set_refuse_new_network_connections(false)

func disallow_connections():
	get_tree().set_refuse_new_network_connections(true)


func on_network_peer_connected(id):
	print('client %s connected!' % id)
	
	register_client(id)


func register_client(id):
	var playerINS = player.instance()
	self.add_child(playerINS)
	playerINS.global_position = Vector2(500,250)
	clients[id] = playerINS
	
	prints("client %s registered" %id)


func on_network_peer_disconnected(id):
	print('client %s disconnected' % id)
	clients[id].queue_free()
	clients.erase(id)


func _notification(what):
	# STOPS SERVER AND UDP BROADCAST AND CLOSES OPEN PORTS
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Server.stop_server()
		UdpBroadcast.stop_broadcast()
		get_tree().quit() # default behavior
