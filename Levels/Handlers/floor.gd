extends Node3D
class_name floor

var transitioning : bool = true
var allowInput : bool = true

var proxy_tilt : Node3D = Node3D.new()
var input_tilt : Vector2
var origin_tilt : Vector2
var relative_skybox_rotation : Vector3 = Vector3.ZERO

var instanced : level
var prev_instance : level
var chosenSpawn : Vector2

var marble : player

@onready var camera = $camera_y
@onready var origin = $Origin
@onready var timer = $RemainingTime
@onready var points = $CanvasLayer/Points
@onready var timerText = $CanvasLayer/Timer
@onready var skybox = $WorldEnvironment.environment

func _ready() -> void:
	timerText.theme.set_color("default_color", "RichTextLabel", RunInfo.playerColor)
	camera.skybox = $WorldEnvironment.environment
	start_game()

func _process(delta: float) -> void:
	if !transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	
	$CanvasLayer/fps.text = "FPS %d" % Engine.get_frames_per_second()
	$CanvasLayer/speed.text = "Speed %.01f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
	if Input.is_action_just_pressed("reset"):
		game_over()
	
	if allowInput:
		handle_tilt(delta)
	else:
		input_tilt = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	
	relative_skybox_rotation += Vector3(0.0001, 0.0002, 0)
	skybox.sky_rotation += Vector3(0.0001, 0.0002, 0)
	
	input_tilt.x = clamp(input_tilt.x, -instanced.max_tilt, instanced.max_tilt)
	input_tilt.y = clamp(input_tilt.y, -instanced.max_tilt, instanced.max_tilt)
	
	origin_tilt.x = deg_to_rad(input_tilt.x * 20)
	origin_tilt.y = deg_to_rad(input_tilt.y * 20)
	
	proxy_tilt.rotation = camera.transform.basis * Vector3(origin_tilt.x, 0, origin_tilt.y)
	
	var a = Quaternion(origin.transform.basis)
	var b = Quaternion(proxy_tilt.transform.basis)
	var c = a.slerp(b,0.1)
	origin.transform.basis = Basis(c)

func handle_tilt(delta : float) -> void:
	var tilt_scalar := 1.00
	if Input.is_action_pressed("pinch"):
		tilt_scalar = 0.25
	match Settings.control_type:
		0:
			var input = Input.get_last_mouse_velocity()
			if input.y > Settings.mouse_deadzone or input.y < -Settings.mouse_deadzone:
				input_tilt.x += input.y * Settings.tilt_sens_keyboard * tilt_scalar * delta
			if input.x > Settings.mouse_deadzone or input.x < -Settings.mouse_deadzone:
				input_tilt.y += -input.x * Settings.tilt_sens_keyboard * tilt_scalar * delta
		1:
			var inputAxis = Input.get_axis("tilt_up", "tilt_down")
			if (inputAxis > Settings.controller_deadzone or inputAxis < -Settings.controller_deadzone):
				input_tilt.x = inputAxis * Settings.tilt_sens_controller * tilt_scalar * delta
			else:
				input_tilt.x = 0
				
			inputAxis = Input.get_axis("tilt_right", "tilt_left")
			if (inputAxis > Settings.controller_deadzone or inputAxis < -Settings.controller_deadzone):
				input_tilt.y = inputAxis * Settings.tilt_sens_controller * tilt_scalar * delta
			else:
				input_tilt.y = 0

func start_game() -> void:
	transitioning = true
	allowInput = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if instanced != null:
		instanced.queue_free()
	
	create_level()
	set_level_data()
	RunInfo.inRun = true
	timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	if marble == null:
		var holder = preload("res://Main/Marble.tscn").instantiate()
		Global.runBase.add_child(holder)
		marble = holder
	
	call_deferred("reset_marble")
	
	await get_tree().create_timer(0.5).timeout
	allowInput = true
	await get_tree().create_timer(0.2).timeout
	Global.runBase.timer.start()
	transitioning = false

func next_level() -> void:
	transitioning = true
	prev_instance = instanced
	
	create_level()
	set_level_data()
	camera.next_level()
	
	await get_tree().create_timer(0.91).timeout
	allowInput = false
	reset_marble()
	marble.visible = true
	
	await get_tree().create_timer(0.5).timeout
	allowInput = true
	await get_tree().create_timer(0.2).timeout
	Global.runBase.timer.start()
	transitioning = false

func set_level_data() -> void:
	chosenSpawn = instanced.start_pos[randi_range(0, instanced.start_pos.size() - 1)]
	
	if RunInfo.inRun:
		timer.set_wait_time(timer.time_left + instanced.given_time)
	else:
		timer.set_wait_time(20)
	
	timer.stop()
	
	if RunInfo.inRun:
		await get_tree().create_timer(0.3).timeout
		prev_instance.queue_free()
		marble.visible = false

	var rot = randf_range(instanced.possible_rotations.x,instanced.possible_rotations.y)
	camera.rotation.y = deg_to_rad(rot)
	camera.skybox.sky_rotation = Vector3(0, deg_to_rad(rot), 0) + relative_skybox_rotation
	
	origin.add_child(instanced)

func pick_level() -> String:
	var dir = DirAccess.open(Global.level_directories[RunInfo.currentDifficulty])
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	var allLevels : Array[String]
	while currentLevel != "":
		if '.tscn.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		allLevels.append(Global.level_directories[RunInfo.currentDifficulty] + currentLevel)
		currentLevel = dir.get_next()
	dir.list_dir_end()
	
	return allLevels[randi_range(0, allLevels.size() - 1)]

func create_level() -> void:
	var chosenLevel = pick_level()
	var current_platform = load(chosenLevel)
	instanced = current_platform.instantiate()

func reset_marble() -> void:
	marble.linear_velocity = Vector3.ZERO
	marble.angular_velocity = Vector3.ZERO
	marble.position = Vector3(chosenSpawn.x,15,chosenSpawn.y)

func reset_orientation() -> void:
	allowInput = false

	camera.rand_rotation(instanced.possible_rotations.x, instanced.possible_rotations.y)
	
	await get_tree().create_timer(0.7).timeout
	allowInput = true

func game_over() -> void:
	if !timer.is_stopped():
		timer.stop()
	var overlay = preload("res://Main/RunEnd.tscn").instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(overlay)

func time_up() -> void:
	game_over()

func killzone_touched(_area: Area3D) -> void:
	reset_marble()
	reset_orientation()
