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

#Accessability Settings
@export var fps_display : bool = false
@export var speed_display : bool = false
