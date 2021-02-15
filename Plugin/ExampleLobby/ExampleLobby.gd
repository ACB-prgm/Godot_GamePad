extends TextureRect


signal player_disconnected(player_name)

var players = {}
var PlayerDisplay = preload("res://ExampleLobby/New_Player_Display.tscn")


func _ready():
# warning-ignore:return_value_discarded
	GamePad.connect("gamepad_connected", self, "_on_GamePad_controller_connected")
# warning-ignore:return_value_discarded
	GamePad.connect("gamepad_disconnected", self, "_on_GamePad_controller_disconnected")


func _on_SearchControllersButton_pressed():
	GamePad.search_for_controllers()


func _on_StartGameButton_pressed():
	GamePad.stop_search_for_controllers()
#	Globals.players = self.players # make an autoload Globals and store the player ids in it
#	get_tree().change_scene("res://Game.tscn")


func _on_GamePad_controller_connected(id):
	var player_name
	var values = []
	for player in players:
		values.append(players.get(player))
		
	for i in range(1, 4):
		var test_player = "player %s" % str(i)
		if !test_player in values:
			player_name = test_player
			break
	players[id] = player_name
	
	var new_player_display = PlayerDisplay.instance()
	new_player_display.player_name = player_name
# warning-ignore:return_value_discarded
	connect("player_disconnected", new_player_display, "_on_player_disconnected")
	add_child(new_player_display)


func _on_GamePad_controller_disconnected(id):
	print(players)
	emit_signal("player_disconnected", players.get(id))
	players.erase(id)
	print(players)
	
	
