extends Node3D

var proxy_tilt = Node3D.new()
var input_tilt : Vector2
var origin_tilt : Vector2
var max_tilt : float = 40
var tilt_scalar : float = 20
var player

var relative_background_rotation : float = 0

@onready var camera = $camera_y
@onready var background = $Background
@onready var origin = $floor_base/Origin
@onready var timer = $RemainingTime
@onready var state = $StateHandler
@onready var points = $CanvasLayer/Points

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	RunInfo.floor = self
	RunInfo.inRun = true
	$CanvasLayer/Timer.theme.set_color("default_color", "RichTextLabel", RunInfo.playerColor)
	state.start_game()
	

func _process(_delta: float) -> void:
	if !state.transitioning:
		$CanvasLayer/Timer.text = "[center]" + "%.1f" % timer.time_left
	else:
		$CanvasLayer/Timer.text = "[center]" + "%.1f" % timer.wait_time
	
	$Background.rotate_y(deg_to_rad(0.01))
	relative_background_rotation += 0.01
	
	var camera_input = Input.get_axis("camera_left", "camera_right")
		
	if (camera_input != 0):
		match Settings.control_type:
			0:
				camera.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_keyboard))
				background.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_keyboard))
			1:
				camera.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_controller))
				background.rotate_y(deg_to_rad(camera_input * Settings.camera_sens_controller))

func _physics_process(_delta: float) -> void:
	if Settings.control_type == 1:
		if Input.get_axis("tilt_up", "tilt_down") != 0:
			input_tilt.x = Input.get_axis("tilt_up", "tilt_down") * Settings.tilt_sens_controller
		else:
			input_tilt.x = 0
		
		if Input.get_axis("tilt_right", "tilt_left") != 0:
			input_tilt.y = Input.get_axis("tilt_right", "tilt_left") * Settings.tilt_sens_controller
		else:
			input_tilt.y = 0

	input_tilt.x = clamp(input_tilt.x, -0.45, 0.45)
	input_tilt.y = clamp(input_tilt.y, -0.45, 0.45)
	
	origin_tilt.x = clamp(deg_to_rad(input_tilt.x * tilt_scalar), deg_to_rad(-max_tilt), deg_to_rad(max_tilt))
	origin_tilt.y = clamp(deg_to_rad(input_tilt.y * tilt_scalar), deg_to_rad(-max_tilt), deg_to_rad(max_tilt))
	
	proxy_tilt.rotation = camera.transform.basis * Vector3(origin_tilt.x, 0, origin_tilt.y)
	
	var a = Quaternion(origin.transform.basis)
	var b = Quaternion(proxy_tilt.transform.basis)
	var c = a.slerp(b,0.15)
	origin.transform.basis = Basis(c)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event.relative.y > 2 or event.relative.y < -2:
				input_tilt.x += event.relative.y * Settings.tilt_sens_keyboard
			if event.relative.x > 2 or event.relative.x < -2:
				input_tilt.y += -event.relative.x * Settings.tilt_sens_keyboard

func game_over() -> void:
	state.game_over()

func reset_player(_area: Area3D) -> void:
	state.reset_player()
	var rotationAmount = deg_to_rad(randf_range(180,360))
	var tween = create_tween()
	tween.tween_property(camera, "rotation", camera.rotation + Vector3(0,rotationAmount,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	var backgroundTween = create_tween()
	backgroundTween.tween_property(background, "rotation", background.rotation + Vector3(0,rotationAmount,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
