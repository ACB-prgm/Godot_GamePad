tool
extends EditorPlugin


var Plugin = preload("res://addons/GamePad_Plugin/InspectorPlugin.gd")
var plugin


func _enter_tree():
	# EditorInspectorPlugin is a resource, so we use `new()` instead of `instance()`.
	var plugin = Plugin.new()
	add_inspector_plugin(plugin)
	


func _exit_tree():
	remove_inspector_plugin(plugin)
