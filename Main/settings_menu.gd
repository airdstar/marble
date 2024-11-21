extends Node

@onready var camera_slider = $CameraSlider
@onready var deadzone_slider = $DeadzoneSlider

func _ready():
	set_control_type_text()
	set_slider_values()

func set_control_type_text():
	if Settings.control_type == Settings.control.KEYBOARD:
		$Button.text = "Keyboard/Mouse"
	else:
		$Button.text = "Controller"

func set_slider_values():
	if Settings.control_type == Settings.control.KEYBOARD:
		camera_slider.min_value = 60
		camera_slider.max_value = 90
		camera_slider.step = 0.5
		camera_slider.value = Settings.camera_sens_keyboard
		
		deadzone_slider.min_value = 0
		deadzone_slider.max_value = 3
		deadzone_slider.step = 1
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
	
	$CameraSlider/CameraSensValue.text = "[center]" + str(snapped((value - camera_slider.min_value)/camera_slider.min_value * 2,0.01))

func deadzone_changed(value: float) -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		Settings.mouse_deadzone = value
	else:
		Settings.controller_deadzone = value
	
	$DeadzoneSlider/DeadzoneValue.text = "[center]" + str(value)
