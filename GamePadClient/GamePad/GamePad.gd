extends Control


onready var tween = $Tween
onready var leftSideControl = $LeftSideControl
onready var rightSideControl = $RightSideControl

var rpcs_to_send = range(4)
var singleButton = preload("res://Buttons/SingleLetterTouchScreenButton.tscn")
var dpad = preload("res://Buttons/Dpad.tscn")
var joystick = preload("res://Buttons/Joystick.tscn")


func _ready():
	leftSideControl.spawn_control(joystick)
	rightSideControl.spawn_control(singleButton, 'bottom', 'B')
	rightSideControl.spawn_control(singleButton, 'right', 'A')
	rightSideControl.spawn_control(singleButton, 'left', 'X')
	rightSideControl.spawn_control(singleButton, 'top', 'Y')
	
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


func _on_direction_calculated(side, direction, intensity):
	if Client.connected:
		for rpc in rpcs_to_send:
			rpc_unreliable_id(1, '_on_input_direction_calculated', side, direction, intensity)
