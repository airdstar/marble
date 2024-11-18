extends Node

func _ready():
	set_control_type_text()

func switch_control_type() -> void:
	if Settings.control_type == Settings.control.KEYBOARD:
		Settings.control_type = Settings.control.CONTROLLER
	else:
		Settings.control_type = Settings.control.KEYBOARD
	set_control_type_text()

func set_control_type_text():
	if Settings.control_type == Settings.control.KEYBOARD:
		$Button.text = "Keyboard/Mouse"
	else:
		$Button.text = "Controller"
