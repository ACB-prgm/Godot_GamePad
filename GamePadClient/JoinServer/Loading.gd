extends TextureRect


func _ready():
	stop()


func _physics_process(_delta):
	self.rect_rotation -= 16


func start():
	show()
	set_physics_process(true)


func stop():
	hide()
	set_physics_process(false)
