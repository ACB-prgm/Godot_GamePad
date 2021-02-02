tool
extends Control


#onready var rightControl = $ColorRect/RightControl
#onready var leftControl = $ColorRect/LeftControl

var dpad_img = preload("res://GamePadImages/Dpad.png")
var joystick_img = preload("res://GamePadImages/Joystick.png")

var _inspector: EditorInspectorPlugin

var right_clicked = false

var device_options = [
	'empty',
	'joystick',
	'd-pad',
	'action buttons',
	'square text button',
	'text input button'
]

var anchor_options = [
	'center',
	'right',
	'left',
	'top',
	'bottom'
]


func create_bg_stylebox(type:int = 1) -> StyleBox:
	var stylebox = StyleBoxFlat.new()
	
	match type:
		1:
			stylebox.set_bg_color(Color(0.25, 0.27, 0.33, 1))
			stylebox.set_border_width_all(1)
			stylebox.set_border_color(Color(0.65, 0.94, 0.67, 1))
		2:
			stylebox.set_bg_color(Color(0.20, 0.22, 0.28, 1))
		3:
			stylebox.set_bg_color(Color(0.15, 0.17, 0.23, 1))
		4:
			stylebox.set_bg_color(Color(0.13, 0.14, 0.19, 1))
	
	return stylebox


func _parse_begin(inspector: EditorInspectorPlugin):
	var title_panel = PanelContainer.new()
	title_panel.set('custom_styles/panel', create_bg_stylebox(1))
	title_panel.set_h_size_flags(3)
	title_panel.set_v_size_flags(3)
	title_panel.rect_min_size = Vector2(0, 55)
	
	var title_container = HBoxContainer.new()
	title_container.set_alignment(1)
	title_panel.add_child(title_container)
	
	var title_texture = TextureRect.new()
	title_texture.set_texture(load("res://GamePad_Layout_Config/GamePad_Icon_large.png"))
	title_texture.set_stretch_mode(6)
	title_container.add_child(title_texture)
	
	var title_text = Label.new()
	title_text.set_text('GamePad Layout Configuration')
	title_container.add_child(title_text)
	
	inspector.add_custom_control(title_panel)
# ———————————————————————————————
	inspector.add_custom_control(InspectorControls.new_space(Vector2(0,25)))
# ———————————————————————————————
	inspector.add_custom_control(load("res://Lobby/TESTDELETE.tscn").instance())
#	var right_control_label = Label.new()
#	right_control_label.set_text('Right Side')
#	right_control_label.set('custom_styles/normal', create_bg_stylebox(2))
#	right_control_label.align = 1
#	inspector.add_custom_control(right_control_label)
#
#	var right_device_optionbutton = OptionButton.new()
#	right_device_optionbutton.align = 2
#	right_device_optionbutton.connect("item_selected", self, "set_right")
#	for option in device_options:
#		right_device_optionbutton.add_item(option)
#	inspector.add_custom_control(right_device_optionbutton)
## ———————————————————————————————
#	var left_control_label = Label.new()
#	left_control_label.set_text('Left Side')
#	left_control_label.set('custom_styles/normal', create_bg_stylebox(2))
#	left_control_label.align = 1
#	inspector.add_custom_control(left_control_label)
#
#	var left_device_optionbutton = OptionButton.new()
#	left_device_optionbutton.align = 2
#	left_device_optionbutton.connect("item_selected", self, "set_left")
#	for option in device_options:
#		left_device_optionbutton.add_item(option)
#	inspector.add_custom_control(left_device_optionbutton)


func set_Dpad_or_Joy(newVar, control):
	var new_texture = TextureRect.new()
	match newVar:
		"D-pad":
			new_texture.set_texture(dpad_img)
		"Joystick":
			new_texture.set_texture(joystick_img)
	control.add_child(new_texture)
	new_texture.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)


func _on_button_toggled(button_pressed):
	if button_pressed:
		right_clicked = true
	else:
		right_clicked = false

func set_right(newVar):
	newVar = device_options[newVar]
	var rightControl = $ColorRect/RightControl

	if newVar != 'Buttons':
		for child in rightControl.get_children():
			child.free()
		set_Dpad_or_Joy(newVar, rightControl)
	else:
		pass


func set_left(newVar):
	newVar = device_options[newVar]
	var leftControl = $ColorRect/LeftControl

	if newVar != 'Buttons':
		for child in leftControl.get_children():
			child.free()
		set_Dpad_or_Joy(newVar, leftControl)
	else:
		pass
