extends Node3D
class_name floor

#Floor Settings
var is_run := false
var set_pool := false
var in_order := false
var allow_timer := false
var timer_count_up := false

#State related
var transitioning : bool = true
var allow_input : bool = false

#Tilt related
var proxy_tilt : Node3D = Node3D.new()
var input_tilt : Vector2
var origin_tilt : Vector2

#Skybox related
var relative_skybox_rotation : Vector3 = Vector3.ZERO
var relative_desired_rotation : Vector3 = Vector3.ZERO

#Instanced related
var level_type : int
var instanced : level
var prev_instance : level
var marble : player
var chosenSpawn : Vector2

#Player related
var settings = PlayerInfo.player_settings

@onready var camera := $camera_y
@onready var origin := $Origin
@onready var skybox = $WorldEnvironment.environment
@onready var timer := $Timer

@onready var level_handler := $LevelHandler
@onready var run_handler := $RunHandler

@onready var timer_text = $UI/Timer
@onready var name_text = $UI/VBoxContainer/name
@onready var fps_text = $UI/VBoxContainer/fps
@onready var speed_text = $UI/VBoxContainer/speed

func _ready() -> void:
	Global.runBase = self
	camera.skybox = skybox
	place_control()

func _process(delta: float) -> void:
	fps_text.text = "FPS %d" % Engine.get_frames_per_second()
	speed_text.text = "Speed %.01f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
	if allow_input:
		handle_tilt(delta)
	else:
		input_tilt = Vector2.ZERO
	
	if allow_timer:
		if !transitioning:
			timer_text.text = "[center]" + "%.1f" % timer.time_left
		else:
			timer_text.text = "[center]" + "%.1f" % timer.wait_time
	
	if Input.is_action_just_pressed("back"):
		game_over()


func _physics_process(_delta: float) -> void:
	
	relative_skybox_rotation += relative_desired_rotation
	skybox.sky_rotation += relative_desired_rotation
	
	input_tilt.x = clamp(input_tilt.x, deg_to_rad(-35), deg_to_rad(35))
	input_tilt.y = clamp(input_tilt.y, deg_to_rad(-35), deg_to_rad(35))
	
	origin_tilt.x = deg_to_rad(input_tilt.x * 20)
	origin_tilt.y = deg_to_rad(input_tilt.y * 20)
	
	proxy_tilt.rotation = camera.transform.basis * Vector3(origin_tilt.x, 0, origin_tilt.y)
	
	var a = Quaternion(origin.transform.basis)
	var b = Quaternion(proxy_tilt.transform.basis)
	var c = a.slerp(b,0.1)
	origin.transform.basis = Basis(c)

func handle_tilt(delta : float) -> void:
	
	var tilt_scalar := 1.0
	
	if Input.is_action_pressed("pinch"):
		tilt_scalar = PlayerInfo.player_settings.tilt_pinch
	
	var input = Input.get_last_mouse_velocity()
	if input.y > settings.tilt_deadzone or input.y < -settings.tilt_deadzone:
		input_tilt.x += input.y * settings.tilt_sens * tilt_scalar * delta
	if input.x > settings.tilt_deadzone or input.x < -settings.tilt_deadzone:
		input_tilt.y += -input.x * settings.tilt_sens * tilt_scalar * delta

func place_control() -> void:
	
	timer_text.set_size(get_window().get_size())
	timer_text.set_position(Vector2(0, get_window().get_size().y / 20))

func start_game() -> void:
	transitioning = true
	allow_input = false
	if is_run:
		run_handler.reset_run()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	set_time()
	
	if instanced != null:
		instanced.queue_free()
	
	level_handler.generate_level(false)
	
	change_skybox_rotation()
	run_handler.inRun = true
	
	if marble == null:
		var holder = preload("res://Main/Marble.tscn").instantiate()
		add_child(holder)
		marble = holder
	
	call_deferred("reset_marble")

func next_level() -> void:
	transitioning = true
	allow_input = false

	camera.next_level()
	change_skybox_rotation()

	marble.visible = false
	prev_instance = instanced
	
	set_time()
	
	level_handler.generate_level(true)


	await get_tree().create_timer(0.91).timeout
	
	reset_marble()

func game_over() -> void:
	if is_run:
		if allow_timer:
			if !timer.is_stopped():
				timer.stop()
		var overlay = preload("res://Levels/Handlers/PlayEnd.tscn").instantiate()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		add_child(overlay)


func set_time() -> void:
	if allow_timer:
		if run_handler.inRun:
			var remaining_time = timer.time_left
			timer.stop()
			var tween = create_tween()
			tween.tween_method(timer.set_wait_time, remaining_time, remaining_time + 4.5, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		else:
			timer.stop()
			timer.set_wait_time(20)

func start_timer():
	timer.start()
	transitioning = false

func change_skybox_rotation() -> void:
	relative_desired_rotation = Vector3(randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003))

func default_camera_skybox() -> void:
	match level_type:
		0:
			camera.allow_input = true
			var rot = randf_range(0, 360)
			camera.rotation.y = deg_to_rad(rot)
			camera.skybox.sky_rotation = Vector3(0, deg_to_rad(rot), 0) + relative_skybox_rotation
		1:
			camera.allow_input = false
			match randi_range(0,1):
				0:
					camera.rotation.y = deg_to_rad(90)
					camera.skybox.sky_rotation = Vector3(0, deg_to_rad(90), 0) + relative_skybox_rotation
				1:
					camera.rotation.y = deg_to_rad(-90)
					camera.skybox.sky_rotation = Vector3(0, deg_to_rad(-90), 0) + relative_skybox_rotation

func reset_marble() -> void:
	marble.visible = true
	marble.linear_velocity = Vector3.ZERO
	marble.angular_velocity = Vector3.ZERO
	marble.position = Vector3(chosenSpawn.x,20,chosenSpawn.y)
	marble.enable_monitoring()

func reset_orientation() -> void:
	allow_input = false
	if level_type == 0:
		camera.rand_rotation(0, 360)

func killzone_touched(_area: Area3D) -> void:
	reset_marble()
	reset_orientation()

func level_generated(level_info : level_resource) -> void:
	name_text.text = level_info.name
	level_type = level_info.level_type
	default_camera_skybox()
	
	instanced.start_level()
	
