tool
extends PanelContainer


onready var children_container = $VBoxContainer
onready var button_label = $VBoxContainer/Label
onready var enabled_button = $VBoxContainer/EnabledCheckBox
onready var button_text_entry = $VBoxContainer/ButtonTextLineEdit
onready var colorSelector = $VBoxContainer/ColorSelector

var controller_location: String = "NA"
var initialized = false
var button_attributes: Dictionary = {
	"button_type": "Button Type",
	"child_number": 0,
	"anchor_location": null,
	"button_text_maxl_length": 1,
	"enabled": true,
	"button_text": "A",
	"color_unpressed": Color(1,1,1,1)
}


signal button_config_changed(button_attributes)


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
	else:
		button_label.set_text("%s %s" % [button_attributes.get("button_type").replace(" ", "_").capitalize(), str(button_attributes.get("child_number"))])
		enabled_button.set_pressed(true)
	
	button_text_entry.set_max_length(button_attributes.get("button_text_maxl_length"))
	
	# Sets the user's past changes if any were made
	var buttons = UI_Builder.load_layout_info().get("%s_buttons" % [controller_location])
	
	var button = exists_in_buttons(buttons, self.button_attributes)
	if button:
		button_attributes = button
		enabled_button.set_pressed(true)
		button_text_entry.set_text(button.get("button_text"))
		colorSelector.set_color(button.get("color_unpressed"))


func exists_in_buttons(buttons, what):
	for button in buttons:
			if button.get("child_number") == what.get("child_number"):
				return button

	return false


func initialize(button_type: int=1, container=null, _controller_location: String="NA"):
	initialized = true
	self.controller_location = _controller_location
	
	self.connect("button_config_changed", container, "_on_button_config_changed")
	
	match button_type:
		1: # ACTION BUTTON
			button_attributes["button_type"] = "action_buttons"
		2:
			button_attributes["button_type"] = "square_text_button"
		3:
			button_attributes["button_type"] = "text_input_button"


func _on_LineEdit_text_changed(new_text):
	button_attributes["button_text"] = new_text
	emit_signal("button_config_changed", button_attributes)


func _on_EnabledCheckBox_toggled(button_pressed):
	button_attributes["enabled"] = button_pressed
	emit_signal("button_config_changed", button_attributes)


func _on_ChildrenContainer_color_changed(color):
	color = color.to_html()
	button_attributes["color_unpressed"] = color
	emit_signal("button_config_changed", button_attributes)
