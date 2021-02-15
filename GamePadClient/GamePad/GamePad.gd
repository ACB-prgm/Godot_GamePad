extends Control


onready var tween = $Tween
onready var left_sideControl = $LeftSideControl
onready var right_sideControl = $RightSideControl

var rpcs_to_send = range(4)
var action_buttons = preload("res://Buttons/SingleLetterTouchScreenButton.tscn")
var dpad = preload("res://Buttons/Dpad.tscn")
var joystick = preload("res://Buttons/Joystick.tscn")
var sides = ["left_side", "right_side"]

func _ready():
	var layout_dict = Client.layout_dict
	
	if !layout_dict:
		left_sideControl.spawn_control(joystick)
#		right_sideControl.spawn_control(singleButton, 'bottom', 'B')
#		right_sideControl.spawn_control(singleButton, 'right', 'A')
#		right_sideControl.spawn_control(singleButton, 'left', 'X')
#		right_sideControl.spawn_control(singleButton, 'top', 'Y')
	else:
		for side in sides:
			if layout_dict.get(side) != "empty":
				var side_control = self.get("%sControl" % side)
				var side_device: String = layout_dict.get(side)
				
				if side_device in ["joystick", "d-pad"]:
					side_control.spawn_control(self.get(side_device.replace("-", "")))
				else: # is a button
					for button_info in layout_dict.get("%s_buttons" % side):
						side_control.spawn_control(self.get(side_device), button_info)
	
	for child in self.get_children():
		if child.get('modulate') and child != $BackgroundTextureRect:
			child.set_modulate(Color(1,1,1,0))
			tween.interpolate_property(child, 'modulate', 
			Color(1,1,1,0), Color(1,1,1,1), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.1)
	tween.start()


func _on_button_pressed(side, button):
	if Client.connected:
		for rpc in rpcs_to_send:
			rpc_unreliable_id(1, '_on_button_pressed', side, button)

func _on_button_released(side, button):
	if Client.connected:
		for rpc in rpcs_to_send:
			rpc_unreliable_id(1, '_on_button_released', side, button)


func _on_direction_calculated(side, direction, intensity, is_joystick):
	if Client.connected:
		if is_joystick: #sends less packets because the joystick sends many packets in and of itself
			if direction == Vector2.ZERO: # sends extra packets when stopping only because these are more likely to be noticed if dropped
				for rpc in rpcs_to_send:
					rpc_unreliable_id(1, '_on_input_direction_calculated', side, direction, intensity)
			else:
				rpc_unreliable_id(1, '_on_input_direction_calculated', side, direction, intensity)
		else:
			for rpc in rpcs_to_send:
				rpc_unreliable_id(1, '_on_input_direction_calculated', side, direction, intensity)
