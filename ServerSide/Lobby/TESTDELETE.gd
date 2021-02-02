tool
extends Button


func _ready():
	print('')

func _parse_begin(inspector):
	print(self)


func _on_Control_pressed():
	print('pressed')
