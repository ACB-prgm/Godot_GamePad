extends Control


signal direction_pressed(direction)
signal direction_released(direction)


func _on_RightButton_pressed():
	emit_signal("direction_pressed", 'right')

func _on_RightButton_released():
	emit_signal("direction_released", 'right')


func _on_Leftbutton_pressed():
	emit_signal("direction_pressed", 'left')

func _on_Leftbutton_released():
	emit_signal("direction_released", 'left')


func _on_DownButton_pressed():
	emit_signal("direction_pressed", 'down')

func _on_DownButton_released():
	emit_signal("direction_released", 'down')


func _on_UpButton_pressed():
	emit_signal("direction_pressed", 'up')

func _on_UpButton_released():
	emit_signal("direction_released", 'up')
