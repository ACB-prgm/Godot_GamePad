extends PanelContainer


const is_panelButton : bool = true
const PRESSED_COLOR := Color(0.4, 0.55, 1, 1.2)

onready var label = $Label

var pressed_style := StyleBoxFlat.new()
var unpressed_style := StyleBoxFlat.new()
var unpressed_color := Color(1,1,1,1)
var button := ""

signal button_pressed(_button)
signal button_released(_button)


func set_panel_button(button_info, side_control) -> void:
	button = button_info.get("button_text")
	unpressed_color = button_info.get("color_unpressed")
	label.set_modulate(unpressed_color)
	label.set_text(button)
	
	unpressed_style = create_tres_from_info(button_info.get("button_stylebox_info"))
	
	for dir in ["right", "left", "top", "bottom"]:
		unpressed_style.set("border_width_%s" % dir, unpressed_style.get("border_width_%s" % dir) * 3)
	set("custom_styles/panel", unpressed_style)
	
	pressed_style = unpressed_style.duplicate()
	pressed_style.border_color = PRESSED_COLOR
	
# warning-ignore:return_value_discarded
	self.connect('button_pressed', side_control, '_on_button_pressed')
# warning-ignore:return_value_discarded
	self.connect('button_released', side_control, '_on_button_released')

# ———————————— EXAMPLE .TRES CONTENTS ————————————
#[gd_resource type="StyleBoxFlat" format=2]
#
#[resource]
#bg_color = Color( 1, 1, 1, 0 )
#border_width_left = 2
#border_width_top = 2
#border_width_right = 2
#border_width_bottom = 2
#border_color = Color( 1, 1, 1, 1 )
#expand_margin_left = 5.0
#expand_margin_right = 5.0
#expand_margin_top = 5.0
#expand_margin_bottom = 5.0



func _on_Button_button_down():
	emit_signal("button_pressed", button)
	set("custom_styles/panel", pressed_style)
	label.set_modulate(PRESSED_COLOR)


func _on_Button_button_up():
	emit_signal("button_released", button)
	set("custom_styles/panel", unpressed_style)
	label.set_modulate(unpressed_color)


func create_tres_from_info(stylebox_info) -> Resource:
	var dir = "res://Buttons/TempStyleboxes/"
	var file_name = "TEMP_FILE"
	var path = dir + "%s.tres" % [file_name]
	var tres_file = File.new()
	var error = tres_file.open(path, File.WRITE)
	if error == OK:
		tres_file.store_string(stylebox_info)
	tres_file.close()
	
	return load(path)
