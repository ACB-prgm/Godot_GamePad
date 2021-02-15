extends EditorProperty
class_name DropDownProperty


var property_name: String = "property_name EditorProperty" # Not currently used
var property: String = "property EditorProperty"
var controller_location: String = "controller_location EditorProperty"
var options_dict = {}
var GamePadLayout_Node

var Property_Container = VBoxContainer.new()
var Option_Button = OptionButton.new()

signal device_changed(property, value)


func _init():
	Property_Container.set('custom_styles/panel', UI_Builder.create_bg_stylebox(2))
	Property_Container.add_child(Option_Button)
	
	Option_Button.set_flat(true)
	Option_Button.connect("item_selected", self, "_on_OptionButton_item_selected")
	
	add_child(Property_Container)
	add_focusable(Property_Container)


func configure_dropdown(propertyname: String, options: Array, ContainerNode):
	self.GamePadLayout_Node = ContainerNode
	self.property = propertyname
	
	if options:
		var index = 0
		for option in options:
			Option_Button.add_item(option.capitalize())
			option = option.to_lower().replace(" ", "_")
			options_dict[option] = index
			index += 1
	if ContainerNode:
		self.connect("device_changed", ContainerNode, "_on_device_changed")


func set_option(option: String):
	Option_Button.select(Option_Button.get_item_index(options_dict.get(option)))
	emit_signal("device_changed", controller_location, property, option)


func _on_OptionButton_item_selected(index: int):
	var changed_option = Option_Button.get_item_text(index).to_lower().replace(" ", "_")
	emit_changed(get_edited_property(), changed_option)
	emit_signal("device_changed", controller_location, property, changed_option)

