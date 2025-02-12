extends Node

@onready var settings_box : VBoxContainer = $Settings
@onready var io_box : VBoxContainer = $IO

@onready var right_size : HSplitContainer = $Settings/HSplitContainer
@onready var middle_size : HSplitContainer = $Settings/HSplitContainer/HSplitContainer

@onready var control_labels : VBoxContainer = $Settings/HSplitContainer/HSplitContainer/Labels/ControlSettings
@onready var control_changers : VBoxContainer = $Settings/HSplitContainer/HSplitContainer/ValueChangers/ControlSettings
@onready var control_values : VBoxContainer = $Settings/HSplitContainer/Values/ControlSettings

@onready var visual_labels : VBoxContainer = $Settings/HSplitContainer/HSplitContainer/Labels/VisualSettings
@onready var visual_changers : VBoxContainer = $Settings/HSplitContainer/HSplitContainer/ValueChangers/VisualSettings
@onready var visual_values : VBoxContainer = $Settings/HSplitContainer/Values/VisualSettings

@onready var bind_labels : VBoxContainer
@onready var bind_changers
@onready var bind_values

@onready var tilt_slider : HSlider = $Settings/HSplitContainer/HSplitContainer/ValueChangers/ControlSettings/TiltSlider
@onready var camera_slider : HSlider = $Settings/HSplitContainer/HSplitContainer/ValueChangers/ControlSettings/CameraSlider
@onready var deadzone_slider : HSlider = $Settings/HSplitContainer/HSplitContainer/ValueChangers/ControlSettings/DeadzoneSlider
@onready var pinch_slider : HSlider = $Settings/HSplitContainer/HSplitContainer/ValueChangers/ControlSettings/PinchSlider

@onready var tilt_value : RichTextLabel = $Settings/HSplitContainer/Values/ControlSettings/TiltSensValue
@onready var camera_value : RichTextLabel = $Settings/HSplitContainer/Values/ControlSettings/CameraSensValue
@onready var deadzone_value : RichTextLabel = $Settings/HSplitContainer/Values/ControlSettings/DeadzoneValue
@onready var pinch_value : RichTextLabel = $Settings/HSplitContainer/Values/ControlSettings/PinchValue


@onready var aspect_options : OptionButton = $Settings/HSplitContainer/HSplitContainer/ValueChangers/VisualSettings/AspectOptions
@onready var res_options : OptionButton = $Settings/HSplitContainer/HSplitContainer/ValueChangers/VisualSettings/ResOptions

@onready var aspect_value : RichTextLabel = $Settings/HSplitContainer/Values/VisualSettings/AspectValue
@onready var res_value : RichTextLabel = $Settings/HSplitContainer/Values/VisualSettings/ResValue

func _ready() -> void:
	for n in Global.aspect_ratios:
		aspect_options.add_item(n)
	set_values()
	place_control()
	show_control_settings()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func place_control() -> void:
	settings_box.call_deferred("set_size", Vector2(get_window().get_size().x / 1.5, get_window().get_size().y))
	settings_box.call_deferred("set_position", Vector2(get_window().get_size().x / 2 - get_window().get_size().x / 3, get_window().get_size().y / 20))
	
	io_box.call_deferred("set_size", Vector2(get_window().get_size().x / 4, get_window().get_size().y))
	io_box.call_deferred("set_position", Vector2(get_window().get_size().x / 2 - get_window().get_size().x / 8, -get_window().get_size().y / 20))
	
	middle_size.split_offset = -get_window().get_size().x / 2.5
	right_size.split_offset = get_window().get_size().x / 1.75

func set_values() -> void:
	tilt_slider.value = (PlayerInfo.player_settings.tilt_sens * 100)
	camera_slider.value = PlayerInfo.player_settings.camera_sens
	deadzone_slider.value = PlayerInfo.player_settings.tilt_deadzone
	pinch_slider.value = PlayerInfo.player_settings.tilt_pinch
	
	for n in aspect_options.item_count:
		if aspect_options.get_item_text(n) == PlayerInfo.player_settings.aspect_ratio:
			aspect_options.selected = n
			set_res_options(n)
	
	aspect_value.text = "[right]" + PlayerInfo.player_settings.aspect_ratio
	res_value.text = "[right]" + PlayerInfo.player_settings.resolution

# Control Settings
func tilt_sens_changed(value : float) -> void:
	tilt_value.text = "[right]%.1f" % (value * 10)
func camera_sens_changed(value: float) -> void:
	camera_value.text = "[right]%.2f" % (value/camera_slider.min_value)
func deadzone_changed(value: float) -> void:
	deadzone_value.text = "[right]%.2f" % (value / deadzone_slider.max_value)
func pinch_changed(value: float) -> void:
	pinch_value.text = "[right]%d" % (pinch_slider.value * 100) + "%"

# Visual Settings
func set_res_options(index : int) -> void:
	res_options.clear()
	var found_res := false
	for n in Global.aspect_ratios[aspect_options.get_item_text(index)]:
		res_options.add_item(n)
		if n == PlayerInfo.player_settings.resolution:
			res_options.selected = res_options.item_count - 1
			found_res = true
	if !found_res:
		res_options.selected = 0

func tab_changed(tab: int) -> void:
	match tab:
		0:
			show_control_settings()
		1:
			show_visual_settings()
		2:
			pass

func show_control_settings() -> void:
	control_labels.visible = true
	control_changers.visible = true
	control_values.visible = true
	
	hide_visual_settings()

func show_visual_settings() -> void:
	visual_labels.visible = true
	visual_changers.visible = true
	visual_values.visible = true
	
	hide_control_settings()

func hide_control_settings() -> void:
	control_labels.visible = false
	control_changers.visible = false
	control_values.visible = false

func hide_visual_settings() -> void:
	visual_labels.visible = false
	visual_changers.visible = false
	visual_values.visible = false

# Others
func save_settings() -> void:
	var settings := PlayerInfo.player_settings
	settings.tilt_sens = tilt_slider.value / 100
	settings.camera_sens = camera_slider.value
	settings.tilt_deadzone = deadzone_slider.value
	settings.tilt_pinch = pinch_slider.value
	
	settings.aspect_ratio = aspect_options.get_item_text(aspect_options.selected)
	if settings.resolution != res_options.get_item_text(res_options.selected):
		settings.resolution = res_options.get_item_text(res_options.selected)
		Global.set_resolution()
		place_control()
		Global.current_scene.place_control()
	
	PlayerInfo.save_settings()
	
	aspect_value.text = "[right]" + PlayerInfo.player_settings.aspect_ratio
	res_value.text = "[right]" + PlayerInfo.player_settings.resolution

func reset_settings() -> void:
	PlayerInfo.player_settings = Settings.new()
	set_values()
