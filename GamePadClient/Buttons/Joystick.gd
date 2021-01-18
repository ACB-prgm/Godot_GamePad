extends TextureRect


signal input_direction_calculated(direction, intensity)

onready var joystickButton = $TouchScreenButton
onready var joystick_center = joystickButton.get_texture().get_size()/2.0
onready var base_boundary = texture.get_width()/2.0
var base_center

var input_vector = Vector2.ZERO
var intensity = 0
var current_touch_index = null
var held = false
var held_check  = false
var calced = false


func _ready():
	set_anchors_preset(Control.PRESET_CENTER)
	set_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	base_center = joystickButton.global_position

func _input(event):
	if held:
		if !held_check:
			held_check = true
			current_touch_index = event.get_index()
		
		if (event is InputEventScreenDrag or event is InputEventScreenTouch) and event.get_index() == current_touch_index:
				var joy_pos_desired = event.position - joystick_center
				joystickButton.set_global_position(joy_pos_desired)
				
				if joy_pos_desired.distance_to(base_center) > base_boundary:
					joystickButton.set_position(base_center.direction_to(joy_pos_desired) * base_boundary + joystick_center)
				
				calculate_input()
				
				intensity = joystickButton.global_position.distance_to(base_center)/base_boundary
				emit_signal("input_direction_calculated", input_vector, intensity)


func _on_TouchScreenButton_released():
	joystickButton.set_global_position(base_center)
	calculate_input()
	emit_signal("input_direction_calculated", Vector2.ZERO, 0)
	held = false
	held_check = false

func _on_TouchScreenButton_pressed():
	held = true

func calculate_input():
	input_vector.y = joystickButton.global_position.y - base_center.y
	input_vector.x = joystickButton.global_position.x - base_center.x
	input_vector = input_vector.normalized()
