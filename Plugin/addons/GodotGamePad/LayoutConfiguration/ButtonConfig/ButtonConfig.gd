tool
extends PanelContainer


const is_button_config := true

onready var children_container = $VBoxContainer
onready var button_label = $VBoxContainer/HBoxContainer/Label
onready var enabled_button = $VBoxContainer/EnabledCheckBox
onready var button_text_entry = $VBoxContainer/ButtonTextLineEdit
onready var colorSelector = $VBoxContainer/ColorSelector
onready var remove_button = $VBoxContainer/HBoxContainer/RemoveButton
onready var styleSelector = $VBoxContainer/StyleSelectHBoxContainer
onready var buttonStyleDisplay = $VBoxContainer/StyleSelectHBoxContainer/ButtonStylDisplayPanel
onready var fileDialog = $VBoxContainer/StyleSelectHBoxContainer/FileDialog

var controller_location: String = "NA"
var initialized = false
var button_attributes: Dictionary = {
	"button_type": "Button Type",
	"child_number": 0,
	"anchor_location": null,
	"button_text_maxl_length": 1,
	"enabled": false,
	"button_text": "A",
	"color_unpressed": Color(1,1,1,1).to_html(),
	"button_stylebox_info" : null
}


signal button_config_changed(button_attributes)
signal button_config_deleted()


func initialize(button_type: int=1, container=null, _controller_location: String="NA"):
	initialized = true
	self.controller_location = _controller_location
	
	self.connect("button_config_changed", container, "_on_button_config_changed")
	self.connect("button_config_deleted", container, "_on_button_config_deleted")
	
	match button_type:
		1: # ACTION BUTTON
			button_attributes["button_type"] = "action_buttons"
		2: # SQUARE TEXT BUTTON
			button_attributes["button_type"] = "square_text_button"
			button_attributes["anchor_location"] = "center"
			button_attributes["button_text_maxl_length"] = 6
		3: # TEXT INPUT BUTTON
			button_attributes["button_type"] = "text_input_button"
			button_attributes["button_text_maxl_length"] = 12


func _ready():
	# Sets up a blank button property
	var parent = get_parent()
	button_attributes["child_number"] = parent.get_child_count() - 2
	
	if button_attributes.get("button_type") == "action_buttons":
		match button_attributes.get("child_number"):
			0:
				button_attributes["anchor_location"] = "Right"
			1:
				button_attributes["anchor_location"] = "Bottom"
			2:
				button_attributes["anchor_location"] = "Left"
			3:
				button_attributes["anchor_location"] = "Top"
		
		button_label.set_text("%s %s" % [button_attributes.get("button_type").replace(" ", "_").capitalize(), button_attributes.get("anchor_location")])
		remove_button.hide()
		styleSelector.hide()
		colorSelector.show()
	else: # TEXT_INPUT OR SQUARE_TEXT BUTTON
		button_attributes["child_number"] = get_child_number()
		button_label.set_text("%s %s" % [button_attributes.get("button_type").replace(" ", "_").capitalize(), str(button_attributes.get("child_number"))])
		button_attributes["enabled"] = true
	
	button_text_entry.set_max_length(button_attributes.get("button_text_maxl_length"))
	
	# Sets the user's past changes if any were made
	var buttons = UI_Builder.load_layout_info().get("%s_buttons" % [controller_location])
#	prints("BUTTON CONFIG", buttons)
	
	var button = exists_in_buttons(buttons, self.button_attributes)
	if button:
		button_attributes = button
		button_text_entry.set_text(button.get("button_text"))
		colorSelector.set_color(button.get("color_unpressed"))
		if button.get("button_stylebox_info"):
			var panel = UI_Builder.create_tres_from_info(button.get("button_stylebox_info"))
			buttonStyleDisplay.set("custom_styles/panel", panel)
	else:
		emit_signal("button_config_changed", button_attributes)
	
	enabled_button.set_pressed(button_attributes.get("enabled"))


func exists_in_buttons(buttons, what):
	for button in buttons:
			if button.get("child_number") == what.get("child_number"):
				return button

	return false


func get_child_number() -> int:
	var child_number := 0
	for child in get_parent().get_children():
		if child.get("is_button_config"):
			child_number += 1
			if child == self:
				return child_number
	
	return child_number


func _on_change_name():
	var child_number = get_child_number()
	button_attributes["child_number"] = child_number
	button_label.set_text("%s %s" % [button_attributes.get("button_type").replace(" ", "_").capitalize(), str(button_attributes.get("child_number"))])


func _on_LineEdit_text_changed(new_text): # CHANGE BUTTON TEXT
	button_attributes["button_text"] = new_text
	emit_signal("button_config_changed", button_attributes)


func _on_EnabledCheckBox_toggled(button_pressed):
	button_attributes["enabled"] = button_pressed
	emit_signal("button_config_changed", button_attributes)


func _on_ChildrenContainer_color_changed(color):
	color = color.to_html()
	button_attributes["color_unpressed"] = color
	emit_signal("button_config_changed", button_attributes)


func _on_RemoveButton_pressed():
	self.queue_free()
	
	button_attributes["enabled"] = false
	emit_signal("button_config_changed", button_attributes)
	emit_signal("button_config_deleted")


func _on_GrabStyleButton_pressed():
	var size = Vector2(1200, 1200)
	fileDialog.popup(Rect2(OS.window_size/2.0 - size/2.0, size))


func _on_FileDialog_file_selected(path):
	var resource = load(path)
	if resource is StyleBox:
		buttonStyleDisplay.set("custom_styles/panel", resource)
		
		var stylebox := ""
		var file = File.new()
		if file.file_exists(path):
			var error = file.open(path, File.READ)
			if error == OK:
				stylebox = file.get_as_text()
			file.close()
		else:
			push_error("LOAD STYLEBOX FAILURE")
		
		button_attributes["button_stylebox_info"] = stylebox
		emit_signal("button_config_changed", button_attributes)
	else:
		push_error("ERR: RESOURCE IS NOT STYLEBOX")
