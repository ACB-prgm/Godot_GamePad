extends VBoxContainer

signal button_pressed(side, button)
signal button_released(side, button)
#signal text_submitted(side, button, _text)
#signal text_changed(side, button, _text)

export (
	String,
	'center',
	'center_top',
	'center_bottom'
	) var side

onready var center = Vector2(
	ProjectSettings.get("display/window/size/width")/2.0,
	ProjectSettings.get("display/window/size/height")/2.0
	)


func spawn_control(control, info: Dictionary={}) -> void:
	var ins_control = control.instance()
	self.add_child(ins_control)
	ins_control.set_panel_button(info, self)


func _on_button_pressed(button):
	emit_signal("button_pressed", side, button)

func _on_button_released(button):
	emit_signal("button_released", side, button)


func set_width(new_width) -> void:
	rect_min_size = Vector2(new_width, 960)
	rect_size = Vector2.ZERO
	rect_pivot_offset = rect_size/2.0
	rect_global_position = Vector2(center.x - rect_pivot_offset.x, center.y - rect_pivot_offset.y)
