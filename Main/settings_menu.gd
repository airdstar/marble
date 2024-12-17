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

@onready var red_slider : HSlider = $Red
@onready var blue_slider : HSlider = $Blue
@onready var green_slider : HSlider = $Green

@onready var background = $Background


func _ready() -> void:
	red_slider.value = PlayerInfo.player_data.player_color.r
	blue_slider.value = PlayerInfo.player_data.player_color.b
	green_slider.value = PlayerInfo.player_data.player_color.g
	
	set_slider_values()

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("back"):
		close_pressed()

func set_slider_values() -> void:
	tilt_slider.value = (PlayerInfo.player_settings.tilt_sens * 100)
	camera_slider.value = PlayerInfo.player_settings.camera_sens
	deadzone_slider.value = PlayerInfo.player_settings.tilt_deadzone
	pinch_slider.value = PlayerInfo.player_settings.tilt_pinch

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
func res_changed(_res: Vector2) -> void:
	pass
func window_type_changed(_type : int) -> void:
	pass

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
	
	PlayerInfo.save_settings()

func reset_settings() -> void:
	PlayerInfo.player_data.player_settings = Settings.new()
	set_slider_values()

func close_pressed() -> void:
	queue_free()

# To be moved
