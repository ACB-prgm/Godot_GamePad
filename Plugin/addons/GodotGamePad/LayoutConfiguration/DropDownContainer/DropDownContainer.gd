tool
extends VBoxContainer
class_name DropDownContainer


var button_config = preload("res://addons/GodotGamePad/LayoutConfiguration/ButtonConfig/ButtonConfig.tscn")
var centerOptions_TSCN = preload("res://addons/GodotGamePad/LayoutConfiguration/DropDownContainer/CenterOptions/CenterOptions.tscn")
var initialized = false
var container_name: String = "Not Init Properly"
var controller_location: String = "controller_location DropDownContainer"
var children_container
var drop_button
var device_dropdown: DropDownProperty
var center_options
var current_value: String
var current_add_button = null
var onready_layout_dict = null

signal update_layout(controller_location, what_to_draw)
signal center_options_changed(controller_location, option, value)
signal button_config_change_name()


func _ready():
	if initialized:
		onready_layout_dict = UI_Builder.load_layout_info()
		
		if onready_layout_dict:
			var selected_device = onready_layout_dict.get(controller_location)
			if selected_device != "empty":
				drop_button.set_pressed(true)
				device_dropdown.set_option(selected_device)


func initialize(button_name: String = "No Container Name Set", LayoutNode = null):
	initialized = true
	controller_location = button_name.to_lower().replace(" ", "_")
#	GamePadLayout_Node = LayoutNode
	connect("update_layout", LayoutNode, "_on_update_layout")
	connect("center_options_changed", LayoutNode, "_on_center_options_changed")
	
	drop_button = $PanelContainer/ToolButton
	container_name = button_name.capitalize()
	drop_button.set_text(container_name)
	
	children_container = $Children_container
	children_container.hide()
	device_dropdown = DropDownProperty.new()
	var children = [device_dropdown]
	if button_name in ["center_top", "center_bottom", "center"]:
		device_dropdown.configure_dropdown("device", UI_Builder.center_device_options, self)
		center_options = centerOptions_TSCN.instance()
		center_options.connect("option_changed", self, "_on_center_options_changed")
		center_options.controller_location = self.controller_location
		children.push_front(center_options)
	else:
		device_dropdown.configure_dropdown("device", UI_Builder.device_options, self)
	add_children(children)


func add_children(children_to_add: Array) -> void:
	var inspector = UI_Builder.load_Inspector()
	
	for child in children_to_add:
		if child is EditorProperty and "property_name" in child:
			child.set_label(" %s %s" % [container_name, child.property.capitalize()])
			var property_name = "%s_%s" % [controller_location.to_lower(), child.property.to_lower()]
			child.controller_location = self.controller_location
			child.property_name = property_name
#			inspector.add_property_editor(property_name ,child)
		children_container.add_child(child)


func remove_children() -> void:
	for child in children_container.get_children():
		if not child in [device_dropdown, center_options]:
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
	emit_signal("update_layout", controller_location, value)
	remove_children() # CLEARS THE INSPECTOR
	
	match value:
		"joystick", "d-pad", "empty":
			emit_signal("update_layout", controller_location, value)
		"square_text_button", "text_input_button":
			var add_button = UI_Builder.create_add_button("Add %s" % value.capitalize(), self, "_on_add_button_pressed")
			current_add_button = add_button
			add_children([add_button])
			
			var buttons = UI_Builder.load_layout_info().get("%s_buttons" % controller_location)
			if buttons:
				for button in buttons:
					_on_add_button_pressed()
		"action_buttons":
			for i in range(4):
				var button_config_instance = button_config.instance()
				button_config_instance.initialize(1, self, controller_location)
				children_container.add_child(button_config_instance)


func _on_center_options_changed(option, value):
	emit_signal("center_options_changed", self.controller_location, option, value)


func _on_add_button_pressed():
	var button_config_instance = button_config.instance()
	match current_value:
		"square_text_button":
			button_config_instance.initialize(2, self, controller_location)
		"text_input_button":
			button_config_instance.initialize(3, self, controller_location)
	self.connect("button_config_change_name", button_config_instance, "_on_change_name")
	children_container.add_child(button_config_instance)


func _on_button_config_deleted():
	yield(get_tree().create_timer(0.01), "timeout")
	emit_signal("button_config_change_name")


func _on_button_config_changed(button_attributes: Dictionary):
	emit_signal("update_layout", controller_location, button_attributes)

