extends Node


const UDP_PORT = 4242

var server := UDPServer.new()


func _ready():
	set_process(false)


func _process(_delta):
# warning-ignore:return_value_discarded
	server.poll()
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		var pkt = peer.get_packet()
		print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		print("Received data: %s" % [pkt.get_string_from_utf8()])
		# Reply so it knows we received the message.
# warning-ignore:return_value_discarded
		peer.put_packet(pkt)


func start_broadcast():
# warning-ignore:return_value_discarded
	server.listen(UDP_PORT)
	set_process(true)
	print('UDP Broadcast Started')


func stop_broadcast():
	server.stop()
	set_process(false)
	print('UDP Broadcast Stopped')
