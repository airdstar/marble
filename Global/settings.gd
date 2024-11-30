extends Resource
class_name Settings

enum control {
	KEYBOARD,
	CONTROLLER
}

@export var control_type : control = control.KEYBOARD

#Camera sens
@export var camera_sens_controller : float = 185
@export var camera_sens_keyboard : float = 70

#Tilt sens
@export var tilt_sens_controller : float = 1.00
@export var tilt_sens_keyboard : float = 0.001

#Deadzone
@export var mouse_deadzone : float = 25
@export var controller_deadzone : float = 0.001

#Pinch
@export var mouse_tilt_pinch : float = 0.5
@export var keyboard_camera_pinch : float = 0.5

#Inversion of controls
@export var invert_tilt_mouse_x : int = 1
@export var invert_tilt_mouse_y : int = 1
@export var invert_tilt_controller_x : int = 1
@export var invert_tilt_controller_y : int = 1
