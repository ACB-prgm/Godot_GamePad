tool
extends PanelContainer


var controller_location

enum {
	WIDTH, # 0
	SEPARATION # 1
}

signal option_changed(option, value)


func _ready():
	var options = UI_Builder.load_layout_info().get("%s_options" % controller_location)
	$VBoxContainer/GridContainer/WidthSpinBox.value = options[0]
	$VBoxContainer/GridContainer/SeparationSpinBox.value = options[1]


func _on_WidthSpinBox_value_changed(value):
	emit_signal("option_changed", WIDTH, value)


func _on_SeparationSpinBox_value_changed(value):
	emit_signal("option_changed", SEPARATION, value)
