extends Control


onready var tween = $Tween

var rpcs_to_send = range(4)

func _ready():
	for child in self.get_children():
		if child.get('modulate') and child != $BackgroundTextureRect:
			child.set_modulate(Color(1,1,1,0))
			tween.interpolate_property(child, 'modulate', 
			Color(1,1,1,0), Color(1,1,1,1), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_Button_button_pressed(button):
	if Client.connected:
		for rpc in rpcs_to_send:
			rpc_unreliable_id(1, 'key_pressed', button)

func _on_Button_button_released(button):
	if Client.connected:
		for rpc in rpcs_to_send:
			rpc_unreliable_id(1, 'key_released', button)


func _on_Dpad_input_direction_calcululated(direction):
	if Client.connected:
		for rpc in rpcs_to_send:
			rpc_unreliable_id(1, 'direction_calculated', direction)
