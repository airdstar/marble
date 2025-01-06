extends Node

@onready var settings_box : VBoxContainer = $SettingsBox
@onready var background : ColorRect = $Background

#@onready var tilt_right : HSplitContainer = $SettingsBox/ControlSettingsBox/TiltSens

@onready var tilt_slider : HSlider = $SettingsBox/ControlSettingsBox/TiltSens/HSplitContainer/TiltSlider
@onready var camera_slider : HSlider = $SettingsBox/ControlSettingsBox/CameraSens/HSplitContainer/CameraSlider
@onready var deadzone_slider : HSlider = $SettingsBox/ControlSettingsBox/Deadzone/HSplitContainer/DeadzoneSlider
@onready var pinch_slider : HSlider = $SettingsBox/ControlSettingsBox/Pinch/HSplitContainer/PinchSlider

@onready var tilt_value : RichTextLabel = $SettingsBox/ControlSettingsBox/TiltSens/TiltSensValue
@onready var camera_value : RichTextLabel = $SettingsBox/ControlSettingsBox/CameraSens/CameraSensValue
@onready var deadzone_value : RichTextLabel = $SettingsBox/ControlSettingsBox/Deadzone/DeadzoneValue
@onready var pinch_value : RichTextLabel = $SettingsBox/ControlSettingsBox/Pinch/PinchValue

@onready var invert_x : CheckButton = $SettingsBox/ControlSettingsBox/InvertX/InvertX
@onready var invert_y : CheckButton = $SettingsBox/ControlSettingsBox/InvertY/InvertY

@onready var res_options : OptionButton = $SettingsBox/VisualSettingsBox/Res/ResOptions
@onready var aspect_options : OptionButton = $SettingsBox/VisualSettingsBox/Aspect/AspectOptions

func _ready() -> void:
	for n in Global.aspect_ratios:
		aspect_options.add_item(n)
	set_values()
	place_control()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)

func place_control() -> void:
	background.set_size(get_window().get_size())
	settings_box.call_deferred("set_size", Vector2(get_window().get_size().x / 2, get_window().get_size().y))
	settings_box.call_deferred("set_position", Vector2(get_window().get_size().x / 4, 0))

func set_values() -> void:
	tilt_slider.value = (PlayerInfo.player_settings.tilt_sens * 100)
	camera_slider.value = PlayerInfo.player_settings.camera_sens
	deadzone_slider.value = PlayerInfo.player_settings.tilt_deadzone
	pinch_slider.value = PlayerInfo.player_settings.tilt_pinch
	
	for n in aspect_options.item_count:
		if aspect_options.get_item_text(n) == PlayerInfo.player_settings.aspect_ratio:
			aspect_options.selected = n
			set_res_options(n)


# Control Settings
func tilt_sens_changed(value : float) -> void:
	tilt_value.text = "[center]%.1f" % (value * 10)
func camera_sens_changed(value: float) -> void:
	camera_value.text = "[center]%.2f" % (value/camera_slider.min_value)
func deadzone_changed(value: float) -> void:
	deadzone_value.text = "[center]%.2f" % (value / deadzone_slider.max_value)
func pinch_changed(value: float) -> void:
	pinch_value.text = "[center]%d" % (pinch_slider.value * 100) + "%"

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
	
	PlayerInfo.save_settings()

func reset_settings() -> void:
	PlayerInfo.player_settings = Settings.new()
	set_values()
