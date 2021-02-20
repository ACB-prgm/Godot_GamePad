extends Control


const is_button = true

signal button_pressed(button)
signal button_released(button)

const PRESSED_COLOR = Color(0.5, 0.65, 1, 1)
var unpressed_color = Color(1, 1, 1, 1)

export var button = ''

onready var label = $Label


func set_button(button_, side_control, color):
	self.button = button_
	label.set_text(button_)
	
	unpressed_color = Color(color)
	set_modulate(unpressed_color)
	
# warning-ignore:return_value_discarded
	self.connect('button_pressed', side_control, '_on_button_pressed')
# warning-ignore:return_value_discarded
	self.connect('button_released', side_control, '_on_button_released')


func _on_TouchScreenButton_pressed():
	emit_signal("button_pressed", button)
	set_modulate(Color(1,1,1,1))
	label.set("custom_colors/font_color", PRESSED_COLOR)

func _on_TouchScreenButton_released():
	emit_signal("button_released", button)
	set_modulate(unpressed_color)
	label.set("custom_colors/font_color", Color(1,1,1,1))
