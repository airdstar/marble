extends Node3D

var camera_sens_controller = 2.5
var camera_sens_mouse = 0.05
var control_type : bool = false
var tilt_sens_controller : float = 1.00
var tilt_sens_keyboard : float = 0.05

var proxy_tilt = Node3D.new()
var input_tilt : Vector2
var origin_tilt : Vector2
var max_tilt : float = 15
var tilt_scalar : float = 20

@onready var camera_rot = $camera_y
@onready var player = $Player
@onready var origin = $Origin


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var current_platform = preload("res://Platform.tscn").instantiate()
	origin.add_child(current_platform)

func _process(delta: float) -> void:
	
	$Background.rotate_y(0.0001)
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	handle_inputs()
	
	
	if control_type:
		var camera_input = Input.get_axis("camera_left", "camera_right")
		
		if (camera_input != 0):
			camera_rot.rotate_y(deg_to_rad(camera_input * camera_sens_controller))
			$Background.rotate_y(deg_to_rad(camera_input * camera_sens_controller))

	
	if Input.is_action_just_pressed("reset"):
		player.position = Vector3(0,2,0)
		player.linear_velocity = Vector3.ZERO
		player.angular_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if control_type:
		
		if Input.get_axis("tilt_up", "tilt_down") != 0:
			input_tilt.x += Input.get_axis("tilt_up", "tilt_down") * tilt_sens_controller
		else:
			input_tilt.x = 0
		
		if Input.get_axis("tilt_right", "tilt_left") != 0:
			input_tilt.y += Input.get_axis("tilt_right", "tilt_left") * tilt_sens_controller
		else:
			input_tilt.y = 0
		
	else:
		
		if Input.get_axis("tilt_up", "tilt_down") != 0:
			input_tilt.x += Input.get_axis("tilt_up", "tilt_down") * tilt_sens_keyboard
		else:
			input_tilt.x = 0
		
		if Input.get_axis("tilt_right", "tilt_left") != 0:
			input_tilt.y += Input.get_axis("tilt_right", "tilt_left") * tilt_sens_keyboard
		else:
			input_tilt.y = 0

	
	input_tilt.x = clamp(input_tilt.x, -0.45, 0.45)
	input_tilt.y = clamp(input_tilt.y, -0.45, 0.45)
	
	origin_tilt.x = clamp(deg_to_rad(input_tilt.x * tilt_scalar), deg_to_rad(-max_tilt), deg_to_rad(max_tilt))
	origin_tilt.y = clamp(deg_to_rad(input_tilt.y * tilt_scalar), deg_to_rad(-max_tilt), deg_to_rad(max_tilt))
	
	proxy_tilt.rotation = camera_rot.transform.basis * Vector3(origin_tilt.x, 0, origin_tilt.y)
	
	var a = Quaternion(origin.transform.basis)
	var b = Quaternion(proxy_tilt.transform.basis)
	var c = a.slerp(b,0.15)
	origin.transform.basis = Basis(c)

func handle_inputs():
	pass

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera_rot.rotate_y(deg_to_rad(-event.relative.x * camera_sens_mouse))
