extends Node

@onready var tilt_slider : HSlider = $VBoxContainer/ControlSettingsBox/TiltSens/HSplitContainer/TiltSlider
@onready var camera_slider : HSlider = $VBoxContainer/ControlSettingsBox/CameraSens/HSplitContainer/CameraSlider
@onready var deadzone_slider : HSlider = $VBoxContainer/ControlSettingsBox/Deadzone/HSplitContainer/DeadzoneSlider
@onready var pinch_slider : HSlider = $VBoxContainer/ControlSettingsBox/Pinch/HSplitContainer/PinchSlider

@onready var tilt_value : RichTextLabel = $VBoxContainer/ControlSettingsBox/TiltSens/TiltSensValue
@onready var camera_value : RichTextLabel = $VBoxContainer/ControlSettingsBox/CameraSens/CameraSensValue
@onready var deadzone_value : RichTextLabel = $VBoxContainer/ControlSettingsBox/Deadzone/DeadzoneValue
@onready var pinch_value : RichTextLabel = $VBoxContainer/ControlSettingsBox/Pinch/PinchValue

@onready var invert_x : CheckButton = $VBoxContainer/ControlSettingsBox/InvertX/InvertX
@onready var invert_y : CheckButton = $VBoxContainer/ControlSettingsBox/InvertY/InvertY

@onready var res_options : OptionButton = $VBoxContainer/VisualSettingsBox/Res/ResOptions
@onready var aspect_options : OptionButton = $VBoxContainer/VisualSettingsBox/Aspect/AspectOptions

func _ready() -> void:
	for n in Global.aspect_ratios:
		aspect_options.add_item(n)
	set_values()

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("back"):
		close_pressed()

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
	PlayerInfo.player_settings.tilt_sens = tilt_slider.value / 100
	PlayerInfo.player_settings.camera_sens = camera_slider.value
	PlayerInfo.player_settings.tilt_deadzone = deadzone_slider.value
	PlayerInfo.player_settings.tilt_pinch = pinch_slider.value
	
	#if invert_x.button_pressed:
		#settings.invert_tilt_x = -1
	#else:
		#settings.invert_tilt_x = 1
	
	#if invert_y.button_pressed:
		#settings.invert_tilt_y = -1
	#else:
		#settings.invert_tilt_y = 1
	
	PlayerInfo.player_settings.aspect_ratio = aspect_options.get_item_text(aspect_options.selected)
	PlayerInfo.player_settings.resolution = res_options.get_item_text(res_options.selected)
	
	Global.set_resolution(Global.aspect_ratios[PlayerInfo.player_settings.aspect_ratio][PlayerInfo.player_settings.resolution])
	
	PlayerInfo.save_settings()

func reset_settings() -> void:
	PlayerInfo.player_settings = Settings.new()
	set_values()

func close_pressed() -> void:
	queue_free()
