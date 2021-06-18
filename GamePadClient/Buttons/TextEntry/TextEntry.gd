extends LineEdit


signal text_submitted(id, _text)

const is_panelButton: bool = true
const styles: Array = ["read_only", "normal", "focus"]

var id = 0


func set_panel_button(button_info) -> void:
	pass
#	set_placeholder(placeholder_text)
#	set_max_length(max_char)
#	set_align(text_align)
#	
#	connect("text_submitted", side_control, "_on_textentry_text_submitted")
#
#	for style in styles:
#		set("custom_styles/%s" % style, stylebox)


func _on_TextEntry_text_entered(new_text):
	emit_signal("text_submitted", self.id, new_text)

func _on_TextEntry_focus_exited():
	emit_signal("text_submitted", self.id, self.get_text())
