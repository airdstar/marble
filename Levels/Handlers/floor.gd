extends Node3D
class_name floor

#State related
var transitioning : bool = true
var allowInput : bool = true

#Tilt related
var proxy_tilt : Node3D = Node3D.new()
var input_tilt : Vector2
var origin_tilt : Vector2

#Skybox related
var relative_skybox_rotation : Vector3 = Vector3.ZERO
var relative_desired_rotation : Vector3 = Vector3.ZERO

#Instanced related
var instanced : level
var prev_instance : level
var marble : player
var chosenSpawn : Vector2

@onready var camera = $camera_y
@onready var origin = $Origin
@onready var timer = $RemainingTime
@onready var points = $CanvasLayer/Points
@onready var timerText = $CanvasLayer/Timer
@onready var skybox = $WorldEnvironment.environment

func _ready() -> void:
	camera.skybox = skybox
	start_game()

func _process(delta: float) -> void:
	if !transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	else:
		timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	$CanvasLayer/fps.text = "FPS %d" % Engine.get_frames_per_second()
	$CanvasLayer/speed.text = "Speed %.01f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
	if Input.is_action_just_pressed("reset"):
		game_over()
	
	if allowInput:
		handle_tilt(delta)
	else:
		input_tilt = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	
	relative_skybox_rotation += relative_desired_rotation
	skybox.sky_rotation += relative_desired_rotation
	
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

	var tilt_scalar := 1.0
	var settings = PlayerInfo.player_data.player_settings

	match settings.control_type:
		0:
			if Input.is_action_pressed("pinch"):
				tilt_scalar = PlayerInfo.player_data.player_settings.mouse_tilt_pinch
			
			var input = Input.get_last_mouse_velocity()
			if input.y > settings.mouse_deadzone or input.y < -settings.mouse_deadzone:
				input_tilt.x += input.y * settings.tilt_sens_keyboard * tilt_scalar * delta
			if input.x > settings.mouse_deadzone or input.x < -settings.mouse_deadzone:
				input_tilt.y += -input.x * settings.tilt_sens_keyboard * tilt_scalar * delta
		1:
			if Input.is_action_pressed("pinch"):
				tilt_scalar = 0.5
			
			var input = Input.get_vector("tilt_up", "tilt_down", "tilt_right", "tilt_left")
			if (input.x > settings.controller_deadzone or input.x < -settings.controller_deadzone) or (input.y > settings.controller_deadzone or input.y < -settings.controller_deadzone):
				input_tilt = input * settings.tilt_sens_controller * tilt_scalar * delta
			else:
				input_tilt = Vector2.ZERO

func start_game() -> void:
	transitioning = true
	allowInput = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if instanced != null:
		instanced.queue_free()
	
	create_level()
	set_level_data()
	change_skybox_rotation()
	RunInfo.inRun = true
	
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
	marble.visible = false
	
	create_level()
	set_level_data()
	camera.next_level()
	change_skybox_rotation()
	
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
	$CanvasLayer/tagline.text = instanced.tagline
	
	if RunInfo.inRun:
		var tween = create_tween()
		tween.tween_method(timer.set_wait_time, timer.time_left, timer.time_left + instanced.given_time, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	else:
		timer.set_wait_time(20)
	
	timer.stop()
	
	if RunInfo.inRun:
		await get_tree().create_timer(0.3).timeout
		prev_instance.queue_free()
		

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

func change_skybox_rotation() -> void:
	relative_desired_rotation = Vector3(randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003))

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
