tool
extends Control
class_name GamePadLayout


var gamePad = preload("res://addons/GodotGamePad/LayoutConfiguration/GamePad_Layout_Config/LayoutConfigColorRect.tscn")
var leftControl
var rightControl
var centerControl

var dpad_img = preload("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/GamePadImages/Dpad.png")
var joystick_img = preload("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/GamePadImages/Joystick.png")

var dropDownContainer = preload("res://addons/GodotGamePad/LayoutConfiguration/DropDownContainer/DropDownContainer.tscn")
var right_side_container: DropDownContainer
var left_side_container: DropDownContainer
var center_container: DropDownContainer

var layout_dict: Dictionary = {
	"left_side": "empty",
	"left_side_buttons": [],
	"right_side": "empty",
	"right_side_buttons": [],
	"center": "empty",
	"center_buttons": []
}


func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	set_anchors_and_margins_preset(Control.PRESET_WIDE, Control.PRESET_MODE_MINSIZE)


func _parse_begin(inspector: EditorInspectorPlugin):
	UI_Builder.save_Inspector(inspector)
	if UI_Builder.load_layout_info():
		layout_dict = UI_Builder.load_layout_info()
	
	for child in self.get_children():
		child.free()
	add_child(gamePad.instance())
	leftControl = $ColorRect/LeftControl
	rightControl = $ColorRect/RightControl
#	centerControl = 

	right_side_container = dropDownContainer.instance()
	left_side_container = dropDownContainer.instance()
	center_container = dropDownContainer.instance()
	
# ——————————— CREATE TITLE/CATEGORY LABEL ———————————
	inspector.add_custom_control(UI_Builder.create_category_header())
# ———————————————————————————————
	right_side_container.initialize("right side", self)
	inspector.add_custom_control(right_side_container)
	
	left_side_container.initialize("left side", self)
	inspector.add_custom_control(left_side_container)


func _on_update_layout(controller_location, what):
	# Modifies layout_dict to match changes
	if typeof(what) == TYPE_STRING and what != "clear":
		if layout_dict.get(controller_location) != what:
			layout_dict["%s_buttons" % [controller_location]].clear()
			
		layout_dict[controller_location] = what.to_lower().replace(" ", "_")
	
	var layout_control
	match controller_location:
			"right_side":
				layout_control = rightControl
			"left_side":
				layout_control = leftControl
			"center":
				layout_control = centerControl
	
	if typeof(what) == TYPE_DICTIONARY: # is a button
#		if layout_dict.get(controller_location) != what.get("button_type"): # Clears buttons when button type is changed
#			layout_dict["%s_buttons" % [controller_location]].clear()
		var button_info = exists_in_buttons(controller_location, what)
		if what.get("enabled"): # Enabled
			if !button_info:
				layout_dict["%s_buttons" % [controller_location]].append(what)
		elif !what.get("enabled"): # Disabled
			if button_info:
				layout_dict["%s_buttons" % [controller_location]].erase(button_info)
	
	# Saves layout_dict to JSON
	UI_Builder.save_layout_info(layout_dict)
	
	# Draws new layout_dict changes to the node for user to see
	if what in ["clear", "empty"]:
		draw_on_layout(controller_location, layout_control, true)
	else:
		draw_on_layout(controller_location, layout_control)


func exists_in_buttons(controller_location, what):
	for button_info in layout_dict.get("%s_buttons" % [controller_location]):
			if button_info.get("child_number") == what.get("child_number"):
				return button_info
		
	return false

func draw_on_layout(controller_location, layout_control: Control, clear=false) -> void:
	for child in layout_control.get_children(): # CLEARS LAYOUT AT CONTROLLER LOCATION
			child.free()
	if clear: # if clear is true, clears the layout screen and ends the function
		return

	var what_to_draw = layout_dict.get(controller_location)
	
	if what_to_draw in ["joystick", "d-pad"]:
		var new_texture = TextureRect.new()
		match what_to_draw:
			"d-pad":
				new_texture.set_texture(dpad_img)
			"joystick":
				new_texture.set_texture(joystick_img)
		layout_control.add_child(new_texture)
		new_texture.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	else: # is a button
		for button in layout_dict.get("%s_buttons" % [controller_location]):
			if button["enabled"]:
				if button.get("button_type") == "action_buttons":
					var new_button = UI_Builder.create_layout_action_button(button.get("button_text"))
					layout_control.add_child(new_button)
					new_button.set_modulate(button.get("color_unpressed"))
					new_button.set_anchors_and_margins_preset(UI_Builder.anchor_option_to_layout_preset(button.get("anchor_location").to_lower()), Control.PRESET_MODE_MINSIZE)
				else:
					pass


#var button_attributes: Dictionary = {
#	"button_type": String, 'action_buttons','square_text_button', 'text_input_button'
#	"child_number": 0,
#	"anchor_location": NULL or, if action button, String == (right, left, top, bottom)
#	"enabled": Bool, draw button on screen
#	"button_text": String, text to set inside button
#	"button_text_maxl_length": int, max length of text to set inside button
#	"color_unpressed": Color(1,1,1,1)

