extends Control


onready var changeSceneTween = $ChangeSceneTween

var faded_in = false


func _ready():
	for child in self.get_children():
		if child != $BackgroundTextureRect and child != changeSceneTween:
			child.set_modulate(Color(1,1,1,0))
			changeSceneTween.interpolate_property(child, 'modulate', 
			Color(1,1,1,0), Color(1,1,1,1), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	changeSceneTween.start()


func _on_ConnectButton_pressed():
	if Client.join_server():
# warning-ignore:return_value_discarded
		change_scene()
	else:
		print('no connection Found')

func change_scene():
	for child in self.get_children():
		if child != $BackgroundTextureRect and child != changeSceneTween:
			changeSceneTween.interpolate_property(child, 'modulate', 
			child.modulate, Color(1,1,1,0), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	changeSceneTween.start()

func _on_ChangeSceneTween_tween_all_completed():
	if faded_in:
		get_tree().change_scene("res://GamePad.tscn")
	faded_in = true
