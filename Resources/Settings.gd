extends Resource
class_name Settings

#Camera Settings
@export var camera_sens := 1.0

#Tilt Settings
@export var tilt_sens := 1.0
@export var tilt_deadzone : float = 25

#Visual Settings
@export var resolution : String = "1280x720"
@export var fullscreen : bool = false

#Accessability Settings
@export var fps_display : bool = false
@export var speed_display : bool = false
