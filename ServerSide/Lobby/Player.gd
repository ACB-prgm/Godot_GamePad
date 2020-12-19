extends KinematicBody2D


const MAX_SPEED = 400
const ACCELERATION = 40
var speed = 400  # speed in pixels/sec
var velocity = Vector2.ZERO

var input_vector = Vector2.ZERO
var A = false
var B = false


func get_input():
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
#		velocity = velocity.normalized() * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
	
	if A:
		set_modulate(Color(0,1,1,1))
	elif B:
		set_modulate(Color(1,0,1,1))
	else:
		set_modulate(Color(1,1,1,1))


func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
