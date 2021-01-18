
extends EditorProperty
class_name MyIntEditor


var updating = false
var spin = EditorSpinSlider.new()


func _init():
	# We'll add an EditorSpinSlider control, which is the same that the
	# inspector already uses for integer and float edition.
	# If you want to put the editor below the property name, use:
	# `set_bottom_editor(spin)`
	# Otherwise to put it inline with the property name use:
	add_child(spin)
	# To remember focus when selected back:
	add_focusable(spin)
	# Setup the EditorSpinSlider
	spin.set_min(0)
	spin.set_max(1000)
	spin.connect("value_changed", self, "_spin_changed")


func _spin_changed(value):
	if (updating):
		return
	emit_changed(get_edited_property(), value)


func update_property():
	var new_value = get_edited_object()[get_edited_property()]
	updating = true
	spin.set_value(new_value)
	updating = false
