extends Node

@onready var camera_slider : HSlider = $CameraSlider
@onready var deadzone_slider : HSlider = $DeadzoneSlider
@onready var swap_control_type : Button = $Button

@onready var deadzone_label : RichTextLabel = $DeadzoneSlider/DeadzoneValue
@onready var camera_sens_label : RichTextLabel = $CameraSlider/CameraSensValue

func _ready() -> void:
	set_control_type_text()
	set_slider_values()

func set_control_type_text() -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		swap_control_type.text = "Keyboard/Mouse"
	else:
		swap_control_type.text = "Controller"

func set_slider_values() -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		camera_slider.min_value = 60
		camera_slider.max_value = 90
		camera_slider.step = 0.5
		camera_slider.value = Settings.camera_sens_keyboard
		
		deadzone_slider.min_value = 1
		deadzone_slider.max_value = 40
		deadzone_slider.step = 0.5
		deadzone_slider.value = Settings.mouse_deadzone
		
		
	else:
		camera_slider.min_value = 140
		camera_slider.max_value = 210
		camera_slider.value = Settings.camera_sens_controller
		camera_slider.step = 1
		
		deadzone_slider.min_value = 0
		deadzone_slider.max_value = 5
		deadzone_slider.step = 1
		deadzone_slider.value = Settings.controller_deadzone

func switch_control_type() -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		Settings.control_type = Settings.control.CONTROLLER
	else:
		Settings.control_type = Settings.control.KEYBOARD
	set_control_type_text()
	set_slider_values()

func camera_sens_changed(value: float) -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		Settings.camera_sens_keyboard = value
	else:
		Settings.camera_sens_controller = value
	
	camera_sens_label.text = "[center]" + str(snapped((value - camera_slider.min_value)/camera_slider.min_value * 2,0.01))

func deadzone_changed(value: float) -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		Settings.mouse_deadzone = value
	else:
		Settings.controller_deadzone = value
	
	deadzone_label.text = "[center]" + str(snapped((value / deadzone_slider.max_value), 0.01))
