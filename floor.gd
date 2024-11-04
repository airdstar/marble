extends Node3D

var camera_sens_controller = 2.5
var camera_sens_mouse = 0.05

var control_type : bool = true

var max_tilt : float = 15
var tilt_sens : float = 20

@onready var camera_rot = $camera_y
@onready var player = $Player


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var current_platform = preload("res://Platform.tscn").instantiate()
	current_platform.rot_info = camera_rot
	add_child(current_platform)

func _process(delta: float) -> void:
	
	$Background.rotate_y(0.0001)
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if control_type:
		var camera_input = Input.get_axis("camera_left", "camera_right")
		
		if (camera_input != 0):
			camera_rot.rotate_y(deg_to_rad(camera_input * camera_sens_controller))
			$Background.rotate_y(deg_to_rad(camera_input * camera_sens_controller))

	
	if Input.is_action_just_pressed("reset"):
		player.position = Vector3(0,2,0)
		player.linear_velocity = Vector3.ZERO
		player.angular_velocity = Vector3.ZERO

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera_rot.rotate_y(deg_to_rad(-event.relative.x * camera_sens_mouse))
