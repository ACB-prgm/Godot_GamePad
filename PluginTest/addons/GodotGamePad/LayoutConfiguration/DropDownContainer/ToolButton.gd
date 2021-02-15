tool
extends ToolButton

var icon_side = preload("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/GuiOptionArrow Side.png")
var icon_down = preload("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/GuiOptionArrow.png")


func _on_ToolButton_toggled(button_pressed):
	if button_pressed:
		set_button_icon(icon_down)
	else:
		set_button_icon(icon_side)
