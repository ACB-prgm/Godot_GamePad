tool
extends EditorPlugin


var InspectorPlugin = preload("res://addons/GodotGamePad/LayoutConfiguration/my_inspector_plugin/MyInspectorPlugin.gd")
var udpBroadcast = "res://addons/GodotGamePad/Networking/UDP_Broadcast.gd"
var server = "res://addons/GodotGamePad/Networking/Server.gd"
var gamePad = "res://addons/GodotGamePad/Networking/GamePad.tscn"


func _enter_tree():
	add_autoload_singleton("UdpBroadcast", udpBroadcast)
	add_autoload_singleton("Server", server)
	add_autoload_singleton("GamePad", gamePad)
	
	InspectorPlugin = InspectorPlugin.new()
	add_inspector_plugin(InspectorPlugin)
	
#	add_custom_type("GamePadLayout", "Control", LayoutConfigScript, LayoutConfigIcon)
	



func _exit_tree():
	remove_inspector_plugin(InspectorPlugin)
