extends Node

enum control {
	KEYBOARD,
	CONTROLLER
}

var control_type : control = control.KEYBOARD

#Camera sens
var camera_sens_controller : float = 185
var camera_sens_keyboard : float = 70

#Tilt sens
var tilt_sens_controller : float = 1.00
var tilt_sens_keyboard : float = 0.001

#Deadzone
var mouse_deadzone : float = 25
var controller_deadzone : float = 0.001

#Pinch
var mouse_tilt_pinch : float = 0.5
var keyboard_camera_pinch : float = 0.5

#Inversion of controls
var invert_tilt_mouse_x : int = 1
var invert_tilt_mouse_y : int = 1
var invert_tilt_controller_x : int = 1
var invert_tilt_controller_y : int = 1
