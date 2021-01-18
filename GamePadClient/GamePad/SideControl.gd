extends Control


signal button_pressed(side, button)
signal button_released(side, button)
signal input_direction_calculated(side, direction, intensity, is_joystick)

export (
	String,
	'left',
	'right'
	) var side

var has_joystick = false

func spawn_control(control, joystick=null, anchor=null, button=null):
	var ins_control = control.instance()
	self.add_child(ins_control)
	
	if button:
		ins_control.set_button(button)
		ins_control.connect('button_pressed', self, '_on_button_pressed')
		ins_control.connect('button_released', self, '_on_button_released')
		
		match anchor:
			'center':
				anchor = Control.PRESET_CENTER
			'right':
				anchor = Control.PRESET_CENTER_RIGHT
			'left':
				anchor = Control.PRESET_CENTER_LEFT
			'top':
				anchor = Control.PRESET_CENTER_TOP
			'bottom':
				anchor = Control.PRESET_CENTER_BOTTOM
		
		ins_control.set_anchors_and_margins_preset(anchor, Control.PRESET_MODE_KEEP_SIZE)
	
	else:
		ins_control.connect('input_direction_calculated', self, '_on_direction_calculated')
		if joystick:
			has_joystick = true


func _on_button_pressed(button):
	emit_signal("button_pressed", self.side, button)

func _on_button_released(button):
	emit_signal("button_released", self.side, button)

func _on_direction_calculated(direction, intensity):
	emit_signal("input_direction_calculated", side, direction, intensity, has_joystick)
