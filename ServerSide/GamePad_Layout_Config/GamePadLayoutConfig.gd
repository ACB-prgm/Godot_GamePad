tool
extends Control


var dpad_img = preload("res://GamePadImages/Dpad.png")
var joystick_img = preload("res://GamePadImages/Joystick.png")


export (
	String,
	"D-pad",
	"Joystick",
	"Buttons"
) var Left_Side = "D-pad" setget set_left

export (
	String,
	"D-pad",
	"Joystick",
	"Buttons"
) var Right_Side = "Buttons" setget set_right



func set_left(newVar):
	Left_Side = newVar
	var leftControl = $ColorRect/LeftControl
	
	if newVar != 'buttons':
		for child in leftControl.get_children():
			child.free()
		set_Dpad_or_Joy(newVar, leftControl)
	else:
		pass
	

func set_right(newVar):
	Right_Side = newVar
	var rightControl = $ColorRect/RightControl
	
	if newVar != 'buttons':
		for child in rightControl.get_children():
			child.free()
		set_Dpad_or_Joy(newVar, rightControl)
	else:
		pass


func set_Dpad_or_Joy(newVar, control):
	var new_texture = TextureRect.new()
	match newVar:
		"D-pad":
			new_texture.set_texture(dpad_img)
		"Joystick":
			new_texture.set_texture(joystick_img)
	control.add_child(new_texture)
	new_texture.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
