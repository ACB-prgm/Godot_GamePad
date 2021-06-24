tool
extends Node
class_name UI_Builder

const device_options = [
	'empty',
	'joystick',
	'd-pad',
	'action buttons',
	'square text button',
	'text input button'
]

const center_device_options = [
	'empty',
	'square text button',
	'text input button'
]

const anchor_options = [
	'center',
	'right',
	'left',
	'top',
	'bottom'
]

var editorInterface#: EditorInterface


static func create_bg_stylebox(type:int = 1) -> StyleBox:
	var stylebox = StyleBoxFlat.new()
	
	match type:
		1: # Category StyleBox.  Grey w/ green outline
			stylebox.set_bg_color(Color(0.25, 0.27, 0.33, 1))
			stylebox.set_border_width_all(1)
			stylebox.set_border_color(Color(0.65, 0.94, 0.67, 1))
		2: # DropDownContainer StyleBox. Medium light gray
			stylebox.set_bg_color(Color(0.20, 0.22, 0.28, 1))
		3: # Property Label. Mediu Blue
			stylebox.set_bg_color(Color(0.15, 0.17, 0.23, 1))
		4: # Property Value. Navy Blue
			stylebox.set_bg_color(Color(0.13, 0.14, 0.19, 1))
		5: # BoxContainer. Transparent BG w/ light grey border.
			stylebox.set_bg_color(Color(1, 1, 1, 0))
			stylebox.set_border_width_all(1)
			stylebox.set_border_color(Color(0.7, 0.7, 0.7, 1))
	
	return stylebox


static func anchor_option_to_layout_preset(anchor_option):
	var layout_preset = Control.PRESET_CENTER
	match anchor_option:
		'center':
			pass
		'right':
			layout_preset = Control.PRESET_CENTER_RIGHT
		'left':
			layout_preset = Control.PRESET_CENTER_LEFT
		'top':
			layout_preset = Control.PRESET_CENTER_TOP
		'bottom':
			layout_preset = Control.PRESET_CENTER_BOTTOM
	
	return layout_preset

static func create_add_button(label_text: String, connect_object, connect_function: String) -> HBoxContainer:
	var add_button = HBoxContainer.new()
	var button_container = PanelContainer.new()
	var button = ToolButton.new()
	var label = Label.new()

	add_button.rect_min_size = Vector2(65, 65)
	add_button.add_child(label)
	add_button.add_child(button_container)
	add_button.add_child(Control.new())
	add_button.set_alignment(2)
	add_button.set("custom_constants/separation", 10)

	label.set_text(label_text)
	label.set_align(2)
	
	button_container.rect_min_size = Vector2(40, 40)
	button_container.set('custom_styles/panel', create_bg_stylebox(4))
	button_container.add_child(button)
	
	button.set_button_icon(load("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/Add.png"))
	button.set_expand_icon(true)
	button.rect_min_size = Vector2(60, 0)
	button.connect("pressed", connect_object, connect_function)

	return add_button


static func create_category_header(title_string: String = "GamePad Layout Configuration") -> PanelContainer:
	var title_panel = PanelContainer.new()
	title_panel.set('custom_styles/panel', create_bg_stylebox(1))
	title_panel.set_h_size_flags(3)
	title_panel.set_v_size_flags(3)
	title_panel.rect_min_size = Vector2(0, 55)
	
	var title_container = HBoxContainer.new()
	title_container.set_alignment(1)
	title_panel.add_child(title_container)
	
	var title_texture = TextureRect.new()
	title_texture.set_texture(load("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/GodotGamepadIcon.svg"))
	title_texture.set_stretch_mode(6)
	title_container.add_child(title_texture)
	
	var title_text = Label.new()
	title_text.set_text(title_string)
	title_container.add_child(title_text)
	
	return title_panel


static func create_layout_action_button(button_text: String) -> CenterContainer:
	var container = CenterContainer.new()
	
	var label = Label.new()
	label.set_text(button_text)
	label.set_theme(load("res://addons/GodotGamePad/LayoutConfiguration/Fonts/GamePadLayoutConfig_FontTheme.tres"))
	container.add_child(label)
	
	var texture = TextureRect.new()
	texture.set_texture(load("res://addons/GodotGamePad/LayoutConfiguration/AddOn_Images/GamePadImages/SingleButton_Unpressed.png"))
	container.add_child(texture)
	
	return container


static func create_layout_panelbutton(button_info, controller_location) -> PanelContainer:
	var new_button = PanelContainer.new()
	
	if button_info.get("button_stylebox_info"):
		var panel = create_tres_from_info(button_info.get("button_stylebox_info"))
		new_button.set("custom_styles/panel", panel)
	
	var label = Label.new()
	label.set_modulate(button_info.get("color_unpressed"))
	label.set("custom_fonts/font", load("res://addons/GodotGamePad/LayoutConfiguration/Fonts/ArialRoundedDynamicfont.tres"))
	label.set_text(button_info.get("button_text"))
	label.set_align(Label.ALIGN_CENTER)
	if button_info.get("button_type") == "text_input_button":
		label.modulate.a = 0.6
	new_button.add_child(label)
	
	return new_button


# SAVING FUNCTIONS
const SAVE_DIR = 'user://UI_Plugin_data/'
const inspector_save_path = SAVE_DIR + 'inspector.dat'
const layoutInfo_save_path = SAVE_DIR + 'layout.dat'


static func save_Inspector(inspector: EditorInspectorPlugin):
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(inspector_save_path, File.WRITE, 'abigail')
	if error == OK:
		
		var inspector_ID = inspector.get_instance_id()
		file.store_var(inspector_ID)
	file.close()


static func load_Inspector() -> EditorInspectorPlugin:
	var inspector = null
	
	var file = File.new()
	if file.file_exists(inspector_save_path):
		var error = file.open_encrypted_with_pass(inspector_save_path, File.READ, 'abigail')
		if error == OK:
			inspector = instance_from_id(file.get_var())
		file.close()
	else:
		print('No Load Data')
	
	return inspector


static func save_layout_info(layout_info: Dictionary):
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open(layoutInfo_save_path, File.WRITE)
	if error == OK:
		file.store_var(layout_info)
	file.close()


static func load_layout_info() -> Dictionary:
	var layout_info = null
	
	var file = File.new()
	if file.file_exists(layoutInfo_save_path):
		var error = file.open(layoutInfo_save_path, File.READ)
		if error == OK:
			layout_info = file.get_var()
		file.close()
	else:
		print('No Layout Saved')
	
	return layout_info


static func create_tres_from_info(stylebox_info) -> Resource:
	var dir = "res://addons/GodotGamePad/LayoutConfiguration/ButtonStyleboxes/"
#	var file_name = "%s_button_%s" % [controller_location, button_info.get("child_number")]
	var file_name = "TEMP_FILE"
	var path = dir + "%s.tres" % [file_name]
	var tres_file = File.new()
	var error = tres_file.open(path, File.WRITE)
	if error == OK:
		tres_file.store_string(stylebox_info)
	tres_file.close()
	
	return load(path).duplicate()


