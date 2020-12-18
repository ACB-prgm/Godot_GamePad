extends Node

const SERVER_PORT = 31416
const MAX_PLAYERS = 4

var ip_adress = '127.0.0.1'
var player = preload("res://Lobby/Player.tscn")
var clients = {}


func _ready():
	for address in IP.get_local_addresses():
		if '192' in address:
			ip_adress = address
			break
	
	get_tree().connect("network_peer_connected", self, "on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "on_network_peer_disconnected")
	
	start_server()


func start_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)


func allow_connections():
	get_tree().set_refuse_new_network_connections(false)


func disallow_connections():
	get_tree().set_refuse_new_network_connections(true)


func quit_game():
	get_tree().set_network_peer(null)
	clients.clear()

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


remote func key_pressed(key):
	var id = get_tree().get_rpc_sender_id()
	var current_player = clients[id]
	current_player.set(key, true)

remote func key_released(key):
	var id = get_tree().get_rpc_sender_id()
	var current_player = clients[id]
	current_player.set(key, false)
