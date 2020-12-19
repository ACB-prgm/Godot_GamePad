extends Control


onready var tween = $Tween


func _ready():
	for child in self.get_children():
		if child != $BackgroundTextureRect and child != tween:
			child.set_modulate(Color(1,1,1,0))
			tween.interpolate_property(child, 'modulate', 
			Color(1,1,1,0), Color(1,1,1,1), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_Button_button_pressed(button):
	if Client.connected:
		rpc_unreliable_id(1, 'key_pressed', button)

func _on_Button_button_released(button):
	if Client.connected:
		rpc_unreliable_id(1, 'key_released', button)


func _on_Dpad_input_direction_calcululated(direction):
	if Client.connected:
		rpc_unreliable_id(1, 'direction_calculated', direction)
