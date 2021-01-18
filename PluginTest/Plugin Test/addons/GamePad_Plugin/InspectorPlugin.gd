extends EditorInspectorPlugin


func can_handle(object):
	# Here you can specify which object types (classes) should be handled by
	# this plugin. For example if the plugin is specific to your player
	# class defined with `class_name MyPlayer`, you can do:
	# `return object is MyPlayer`
	# In this example we'll support all objects, so:
	return true


func parse_property(object, type, path, hint, hint_text, usage):
	# We will handle properties of type integer.
	if type == TYPE_INT:
		# Register *an instance* of the custom property editor that we'll define next.
		add_property_editor(path, MyIntEditor.new())
		# We return `true` to notify the inspector that we'll be handling
		# this integer property, so it doesn't need to parse other plugins
		# (including built-in ones) for an appropriate editor.
		return true
	else:
		return false
