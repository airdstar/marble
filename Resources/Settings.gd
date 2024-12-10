extends Resource
class_name Settings

enum control {
	KEYBOARD
}

@export var control_type : control = control.KEYBOARD

#Camera sens
@export var camera_sens_keyboard : float = 70

#Tilt sens
@export var tilt_sens_keyboard : float = 0.001

#Deadzone
@export var mouse_deadzone : float = 25

#Pinch
@export var mouse_tilt_pinch : float = 0.5
@export var keyboard_camera_pinch : float = 0.5

#Inversion of controls
@export var invert_tilt_mouse_x : int = 1
@export var invert_tilt_mouse_y : int = 1

func check_info() -> void:
	if control_type == null:
		control_type = control.KEYBOARD
	
	if camera_sens_keyboard == null:
		camera_sens_keyboard = 70
	if tilt_sens_keyboard == null:
		tilt_sens_keyboard = 0.001
	
	if mouse_deadzone == null:
		mouse_deadzone = 10
	
	if mouse_tilt_pinch == null:
		mouse_tilt_pinch = 0.5
	
	if invert_tilt_mouse_x == null:
		invert_tilt_mouse_x = 1
	if invert_tilt_mouse_y == null:
		invert_tilt_mouse_y = 1
