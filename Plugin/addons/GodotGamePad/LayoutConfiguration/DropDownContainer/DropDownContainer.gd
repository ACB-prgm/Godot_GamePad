tool
extends VBoxContainer
class_name DropDownContainer


var button_config = preload("res://addons/GodotGamePad/LayoutConfiguration/ButtonConfig/ButtonConfig.tscn")
var initialized = false
var container_name: String = "Not Init Properly"
var controller_location: String = "controller_location DropDownContainer"
var children_container
var drop_button
var device_dropdown: DropDownProperty
#var GamePadLayout_Node
var current_value: String
var current_add_button = null
var onready_layout_dict = null

signal update_layout(controller_location, what_to_draw)


func _ready():
	if initialized:
		onready_layout_dict = UI_Builder.load_layout_info()
		
		var selected_device = onready_layout_dict.get(controller_location)
		if selected_device != "empty":
			drop_button.set_pressed(true)
			device_dropdown.set_option(selected_device)
		
		


func initialize(button_name: String = "No Container Name Set", LayoutNode = null):
	initialized = true
	controller_location = button_name.to_lower().replace(" ", "_")
#	GamePadLayout_Node = LayoutNode
	connect("update_layout", LayoutNode, "_on_update_layout")
	
	drop_button = $PanelContainer/ToolButton
	container_name = button_name.capitalize()
	drop_button.set_text(container_name)
	
	children_container = $Children_container
	children_container.hide()
	device_dropdown = DropDownProperty.new()
	device_dropdown.configure_dropdown("device", UI_Builder.device_options, self)
	add_children([device_dropdown])


func add_children(children_to_add: Array) -> void:
	var inspector = UI_Builder.load_Inspector()
	
	for child in children_to_add:
		if child is EditorProperty and "property_name" in child:
			child.set_label(" %s %s" % [container_name, child.property.capitalize()])
			var property_name = "%s_%s" % [controller_location.to_lower(), child.property.to_lower()]
			child.controller_location = self.controller_location
			child.property_name = property_name
			inspector.add_property_editor(property_name ,child)
		# Throws Error  "Can't add child 'EditorProperty' to '@@3874', already has a parent 'Children_container'."
		children_container.add_child(child)


func remove_children() -> void:
	for child in children_container.get_children():
		if child != device_dropdown:
			child.free()


func _on_ToolButton_toggled(button_pressed) -> void:
	if button_pressed:
		children_container.show()
	else:
		children_container.hide()


func _on_device_changed(controller_location, property: String, value: String):
	var inspector = UI_Builder.load_Inspector()
	current_value = value
	
#	if is_instance_valid(current_add_button):
#		current_add_button.free()
#	emit_signal("update_layout", controller_location, "clear") # CLEARS THE GAMEPAD LAYOUT
	emit_signal("update_layout", controller_location, value)
	remove_children() # CLEARS THE INSPECTOR
	
	match value:
		"joystick", "d-pad", "empty":
			emit_signal("update_layout", controller_location, value)
		"square_text_button", "text_input_button":
			var add_button = UI_Builder.create_add_button("Add %s" % value.capitalize(), self, "_on_add_button_pressed")
			current_add_button = add_button
			add_children([add_button])
		"action_buttons":
			for i in range(4):
				var button_config_instance = button_config.instance()
				button_config_instance.initialize(1, self, controller_location)
				children_container.add_child(button_config_instance)

func _on_add_button_pressed():
	match current_value:
		"square_tex_button":
			pass
		"text_input_button":
			pass

func _on_button_config_changed(button_attributes: Dictionary):
	emit_signal("update_layout", controller_location, button_attributes)

