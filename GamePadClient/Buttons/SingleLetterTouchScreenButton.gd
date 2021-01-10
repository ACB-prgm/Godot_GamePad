extends Control


signal button_pressed(button)
signal button_released(button)

const PRESSED_COLOR = Color(0.5, 0.65, 1, 1)
const UNPRESSED_COLOR = Color(1, 1, 1, 1)

export var button = ''

onready var label = $Label


func set_button(button_):
	self.button = button_
	label.set_text(button)

func _on_TouchScreenButton_pressed():
	emit_signal("button_pressed", button)
	label.set("custom_colors/font_color", PRESSED_COLOR)

func _on_TouchScreenButton_released():
	emit_signal("button_released", button)
	label.set("custom_colors/font_color", UNPRESSED_COLOR)
