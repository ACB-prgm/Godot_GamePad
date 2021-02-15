tool
extends HBoxContainer


signal color_changed(color)

onready var colorPickerPopup = $ColorPickerPopupPanel
onready var button = $Button

var colorPickerSize = Vector2(336, 462)


func set_color(color: Color):
	button.set_modulate(color)
	$ColorPickerPopupPanel/ColorPicker.set_pick_color(color)

func _on_Button_pressed():
	colorPickerPopup.popup(Rect2($Position2D.global_position + Vector2(-colorPickerSize.x*1.7, 0), colorPickerSize))


func _on_PopupPanel_focus_exited():
	colorPickerPopup.hide()


func _on_ColorPicker_color_changed(color):
	button.set_modulate(color)
	emit_signal("color_changed", color)
