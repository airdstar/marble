extends Resource
class_name Settings

#Camera Settings
@export var camera_sens : float = 70

#Tilt Settings
@export var tilt_sens : float = 0.001
@export var tilt_deadzone : float = 25
@export var tilt_pinch : float = 0.5

#Visual Settings
@export var aspect_ratio : String = "16:9"
@export var resolution : String = "1280x720"
@export var fullscreen : bool = false


func check_info() -> void:
	if camera_sens == null:
		camera_sens = 70
	
	if tilt_sens == null:
		tilt_sens = 0.001
	if tilt_deadzone == null:
		tilt_deadzone = 10
	if tilt_pinch == null:
		tilt_pinch = 0.5
