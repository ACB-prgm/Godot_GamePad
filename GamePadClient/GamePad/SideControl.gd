extends Control


signal button_pressed(side, button)
signal button_released(side, button)
signal text_submitted(side, id, _text)
signal input_direction_calculated(side, direction, intensity, is_joystick)

export (
	String,
	'left',
	'right'
	) var side

var has_joystick = false


func spawn_control(control, info: Dictionary={}):
	var ins_control = control.instance()
	self.add_child(ins_control)
	
	if ins_control.get("is_directional"): # if directional input, sets and returns
		ins_control.connect('input_direction_calculated', self, '_on_direction_calculated')
		if ins_control.get("is_joystick"):
			has_joystick = true
	
	else: # Not directional
		var anchor = Control.PRESET_CENTER
		match info.get("anchor_location").to_lower():
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
		
		# Device speciffic configurations
		if ins_control.get("is_button"):
			ins_control.set_button(info.get("button_text"), self, info.get("color_unpressed"))
		
		elif ins_control.get("is_textentry"):
			ins_control.set_textentry(self, "main", "hello", load("res://Buttons/TextEntry/default_stylebox.tres"), 5, 1)


func _on_button_pressed(button):
	emit_signal("button_pressed", self.side, button)

func _on_button_released(button):
	emit_signal("button_released", self.side, button)


func _on_textentry_text_submitted(id, _text):
	emit_signal("text_submitted", self.side, id, _text)


func _on_direction_calculated(direction, intensity):
	emit_signal("input_direction_calculated", self.side, direction, intensity, has_joystick)
