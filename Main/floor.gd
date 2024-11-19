extends Node3D

var proxy_tilt = Node3D.new()
var input_tilt : Vector2
var origin_tilt : Vector2
var max_tilt : float = deg_to_rad(35)
var tilt_scalar : float = 20

var relative_background_rotation : float = 0
var overlay

@onready var camera = $camera_y
@onready var background = $Background
@onready var origin = $floor_base/Origin
@onready var timer = $RemainingTime
@onready var state = $StateHandler
@onready var points = $CanvasLayer/Points
@onready var timerText = $CanvasLayer/Timer

func _ready():
	timerText.theme.set_color("default_color", "RichTextLabel", RunInfo.playerColor)
	state.start_game()

func _process(delta: float) -> void:
	if !state.transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	else:
		timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	$Background.rotate_y(deg_to_rad(0.01))
	relative_background_rotation += 0.01
	
	var camera_input = Input.get_axis("camera_left", "camera_right")
		
	if (camera_input != 0):
		match Settings.control_type:
			0:
				camera.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_keyboard) * delta)
				background.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_keyboard) * delta)
			1:
				camera.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_controller) * delta)
				background.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_controller) * delta)

func _physics_process(_delta: float) -> void:
	
	if Settings.control_type == 1:
		var inputAxis = Input.get_axis("tilt_up", "tilt_down")
		if (inputAxis > Settings.controller_deadzone or inputAxis < -Settings.controller_deadzone) and state.allowInput:
			input_tilt.x = inputAxis * Settings.tilt_sens_controller
		else:
			input_tilt.x = 0
		
		inputAxis = Input.get_axis("tilt_right", "tilt_left")
		if (inputAxis > Settings.controller_deadzone or inputAxis < -Settings.controller_deadzone) and state.allowInput:
			input_tilt.y = inputAxis * Settings.tilt_sens_controller
		else:
			input_tilt.y = 0
	
	input_tilt.x = clamp(input_tilt.x, -max_tilt, max_tilt)
	input_tilt.y = clamp(input_tilt.y, -max_tilt, max_tilt)
	
	origin_tilt.x = deg_to_rad(input_tilt.x * tilt_scalar)
	origin_tilt.y = deg_to_rad(input_tilt.y * tilt_scalar)
	
	proxy_tilt.rotation = camera.transform.basis * Vector3(origin_tilt.x, 0, origin_tilt.y)
	
	var a = Quaternion(origin.transform.basis)
	var b = Quaternion(proxy_tilt.transform.basis)
	var c = a.slerp(b,0.1)
	origin.transform.basis = Basis(c)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if state.allowInput:
				if event.relative.y > Settings.mouse_deadzone or event.relative.y < -Settings.mouse_deadzone:
					input_tilt.x += event.relative.y * Settings.tilt_sens_keyboard
				if event.relative.x > Settings.mouse_deadzone or event.relative.x < -Settings.mouse_deadzone:
					input_tilt.y += -event.relative.x * Settings.tilt_sens_keyboard
			else:
				input_tilt = Vector2.ZERO

func game_over() -> void:
	overlay = preload("res://Main/RunEnd.tscn").instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(overlay)

func reset_player(_area: Area3D) -> void:
	state.reset_player()
	state.reset_orientation()
