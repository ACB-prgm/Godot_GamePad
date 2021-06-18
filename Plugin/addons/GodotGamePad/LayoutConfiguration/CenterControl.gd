tool
extends VBoxContainer


onready var center_x = ProjectSettings.get("display/window/size/width")/2.0

func _ready():
	if Engine.editor_hint:
		set_process(true)
	else:
		set_process(false)

func _process(delta):
	if Engine.editor_hint:
		if !center_x:
			center_x = ProjectSettings.get("display/window/size/width")/2.0
		
		rect_pivot_offset = rect_size/2.0
		rect_size = Vector2.ZERO
		rect_global_position.x = center_x - rect_pivot_offset.x
