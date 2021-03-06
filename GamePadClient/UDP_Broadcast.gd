extends Node

const UDP_PORT = 4242
var udp := PacketPeerUDP.new()
var udp_connected = false


func _ready():
	set_process(false)
# warning-ignore:return_value_discarded
	udp.set_dest_address("255.255.255.255", UDP_PORT)
	udp.set_broadcast_enabled(true)


func get_server_ip():
	if !Client.host_ip_address:
		set_process(true)
	else:
		Client.join_server()


func stop_broadcast():
#	print('stopping UDP Broadcast')
	set_process(false)


func _process(_delta):
	if !udp_connected:
		# Try to contact server
# warning-ignore:return_value_discarded
		udp.put_packet("Contacted Host".to_utf8())
	
	if udp.get_available_packet_count() > 0:
		var layout = JSON.parse(udp.get_packet().get_string_from_utf8()).result
		if typeof(layout) == TYPE_DICTIONARY:
			Client.layout_dict = layout
		Client.host_ip_address = udp.get_packet_ip()
		Client.join_server()
		
		# Stop Broadcasting
		udp_connected = true
		set_process(false)
