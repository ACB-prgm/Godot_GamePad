extends Node


const UDP_PORT = 4242

var server := UDPServer.new()
var is_broadcasting = false
var layout


func _ready():
	set_process(false)
	layout = JSON.print(UI_Builder.load_layout_info()).to_utf8()


func _process(_delta):
# warning-ignore:return_value_discarded
	server.poll()
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		var pkt = peer.get_packet()
#		print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
#		print("Received data: %s" % [pkt.get_string_from_utf8()])
		# Reply so it knows we received the message.
# warning-ignore:return_value_discarded
		peer.put_packet(layout)


func start_broadcast():
# warning-ignore:return_value_discarded
	server.listen(UDP_PORT)
	set_process(true)
	
	is_broadcasting = true
#	print('UDP Broadcast Started')


func stop_broadcast():
	server.stop()
	set_process(false)
	
	is_broadcasting = false
#	print('UDP Broadcast Stopped')
