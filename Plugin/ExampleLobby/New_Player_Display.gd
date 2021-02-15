extends TextureRect


const RED = Color(0.78, 0.25, 0.25, 1)
const BLUE = Color(0.25, 0.35, 0.78, 1)
const YELLOW = Color(0.78, 0.7, 0.25, 1)
const GREEN = Color(0.3, 0.6, 0.2, 1)

onready var tween = $Tween

var player_name: String = "player 1"


func _ready():
	match player_name:
		"player 1":
			self_modulate = RED
			rect_position = Vector2(45, 286)
		"player 2":
			self_modulate = BLUE
			rect_position = Vector2(267, 286)
		"player 3":
			self_modulate = YELLOW
			rect_position = Vector2(495, 286)
		"player 4":
			self_modulate = GREEN
			rect_position = Vector2(720, 286)
	
	$Label.set_text(player_name)


func _on_player_disconnected(player: String) -> void:
	if player == player_name:
		self.queue_free()
