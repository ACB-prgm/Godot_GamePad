extends Label


onready var tween = $Tween

func _ready():
	set_modulate(Color(1,1,1,0))


func display_message(message, fade=true, tween_time=1, delay=0):
	set_text(message)
	set_modulate(Color(1,1,1,1))
	tween.stop_all()
	
	if fade:
		tween.interpolate_property(self, 'modulate', 
			Color(1,1,1,1), Color(1,1,1,0), tween_time, 
			Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay)
		tween.start()
