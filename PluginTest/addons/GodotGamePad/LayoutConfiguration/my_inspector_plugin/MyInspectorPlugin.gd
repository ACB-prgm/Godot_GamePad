tool
extends EditorInspectorPlugin


func can_handle(object):
	return true


func parse_begin(object):
	if object.has_method("_parse_begin"):
		object._parse_begin(self)


func parse_property(object, type, path, hint, hint_text, usage):
	if object.has_method("_parse_property"):
		object._parse_property(self, type, path, hint, hint_text, usage)
