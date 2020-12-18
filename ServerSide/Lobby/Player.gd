extends KinematicBody2D

var speed = 400  # speed in pixels/sec
var velocity = Vector2.ZERO

var right = false
var left = false
var up = false
var down = false
var A = false
var B = false


func get_input(delta):
	velocity = Vector2.ZERO
	if right:
		velocity.x += 1
	if left:
		velocity.x -= 1
	if down:
		velocity.y += 1
	if up:
		velocity.y -= 1
	
	if A:
		set_modulate(Color(0,1,1,1))
	elif B:
		set_modulate(Color(1,0,1,1))
	else:
		set_modulate(Color(1,1,1,1))

	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input(delta)
	velocity = move_and_slide(velocity)
