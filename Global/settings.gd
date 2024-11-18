extends Node

enum control {
	KEYBOARD,
	CONTROLLER
}

var control_type : control = control.KEYBOARD

var camera_sens_controller : float = 2.5
var camera_sens_keyboard : float = 1
var tilt_sens_controller : float = 1.00
var tilt_sens_keyboard : float = 0.001
var mouse_deadzone : float = 1
var controller_deadzone : float = 0.01
