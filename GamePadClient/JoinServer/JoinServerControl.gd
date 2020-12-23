extends Control


onready var changeSceneTween = $ChangeSceneTween
onready var connectingTimer = $ConnectingTimer
onready var loading_img = $Loading
onready var message = $Message

var faded_in = false
var connection_attempts = 0
var join_attempted = false


func _ready():
	for child in self.get_children():
		if child.get('modulate') and child != $BackgroundTextureRect and child != message:
			child.set_modulate(Color(1,1,1,0))
			changeSceneTween.interpolate_property(child, 'modulate', 
			Color(1,1,1,0), Color(1,1,1,1), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	changeSceneTween.start()


func _on_ConnectButton_pressed():
	UdpBroadcast.get_server_ip()
	connectingTimer.start()
	message.display_message("Connecting...", false)
	loading_img.start()


func _on_ConnectingTimer_timeout():
	if connection_attempts < 60:
		connection_attempts += 1
		
		if Client.connected:
			connection_attempts = 0
			connectingTimer.stop()
			message.display_message('Connected!')
			change_scene()

	else:
		message.display_message('No Server Found', true, 2, 2)
		connection_attempts = 0
		connectingTimer.stop()
		loading_img.stop()


func change_scene():
	for child in self.get_children():
		if child.get('modulate') and child != $BackgroundTextureRect:
			changeSceneTween.interpolate_property(child, 'modulate', 
			child.modulate, Color(1,1,1,0), 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	changeSceneTween.start()

func _on_ChangeSceneTween_tween_all_completed():
	if faded_in:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://GamePad.tscn")
	faded_in = true
