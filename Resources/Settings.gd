extends Resource
class_name Settings

#Camera Options
@export var camera_sens : float = 70

#Tilt Options
@export var tilt_sens : float = 0.001
@export var tilt_deadzone : float = 25
@export var tilt_pinch : float = 0.5

#Inversion of Controls ( 1 means not inverted, -1 means inverted)
@export var invert_tilt_x : int = 1
@export var invert_tilt_y : int = 1

func check_info() -> void:
	if camera_sens == null:
		camera_sens = 70
	
	if tilt_sens == null:
		tilt_sens = 0.001
	if tilt_deadzone == null:
		tilt_deadzone = 10
	if tilt_pinch == null:
		tilt_pinch = 0.5
	
	if invert_tilt_x == null:
		invert_tilt_x = 1
	if invert_tilt_y == null:
		invert_tilt_y = 1
