extends Node3D
class_name floor

#Floor Settings
var is_run := false
var set_pool := false
var in_order := false

# If floor is on a timer
var allow_timer := false
# If timer should count up
var timer_count_up := false
var time_taken : float = 0.0

#State related
var transitioning : bool = true
var allow_input : bool = false

#Tilt related
var proxy_tilt : Quaternion = Quaternion.IDENTITY
var input_tilt : Vector2

#Skybox related
var relative_skybox_rotation : Vector3 = Vector3.ZERO
var relative_desired_rotation : Vector3 = Vector3.ZERO

#Instanced related
var level_type : int
var instanced : level
var prev_instance : level
var marble : player


#Player related
var settings = PlayerInfo.player_settings

@export var UI : Control
@export var timer_text : RichTextLabel
@export var secondary_timer_text : RichTextLabel

@onready var camera := $camera_y
@onready var origin := $Origin
@onready var timer : Timer = $Timer

@onready var level_handler : LevelHandler = $LevelHandler
@onready var run_handler : RunHandler = $RunHandler

@onready var name_text = $UI/name
@onready var fps_text = $UI/VBoxContainer/fps
@onready var speed_text = $UI/VBoxContainer/speed

func _ready() -> void:
	place_control()

func _process(delta: float) -> void:
	if UI.visible:
		fps_text.text = "FPS: %d" % Engine.get_frames_per_second()
		speed_text.text = "Speed: %.2f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
	if allow_input:
		var input = Input.get_last_mouse_velocity()
		var tilt_transform = camera.transform.basis * Vector3(input.x, 0, input.y)
		input = Vector2(tilt_transform.x, tilt_transform.z)
		var prev_input = input_tilt
		if input.y > settings.tilt_deadzone or input.y < -settings.tilt_deadzone:
			input_tilt.x += input.y * settings.tilt_sens * delta
			input_tilt.x = clamp(input_tilt.x, deg_to_rad(-15), deg_to_rad(15))
		if input.x > settings.tilt_deadzone or input.x < -settings.tilt_deadzone:
			input_tilt.y += -input.x * settings.tilt_sens * delta
			input_tilt.y = clamp(input_tilt.y, deg_to_rad(-15), deg_to_rad(15))
		
		
		if prev_input != input_tilt:
			proxy_tilt = Quaternion(
			sin(input_tilt.x/2) * cos(0) * cos(input_tilt.y/2) - cos(input_tilt.x/2) * sin(0) * sin(input_tilt.y/2),
			cos(input_tilt.x/2) * sin(0) * cos(input_tilt.y/2) + sin(input_tilt.x/2) * cos(0) * sin(input_tilt.y/2),
			cos(input_tilt.x/2) * cos(0) * sin(input_tilt.y/2) - sin(input_tilt.x/2) * sin(0) * cos(input_tilt.y/2),
			cos(input_tilt.x/2) * cos(0) * cos(input_tilt.y/2) + sin(input_tilt.x/2) * sin(0) * sin(input_tilt.y/2)
			)
	else:
		input_tilt = Vector2.ZERO
		proxy_tilt = Quaternion.IDENTITY
	
	if allow_timer:
		if !transitioning:
			if timer_count_up:
				time_taken += delta
				timer_text.text = "[center]%.2f" % time_taken
			else:
				timer_text.text = "[center]%d" % timer.time_left
				secondary_timer_text.text = "[center]%03d" % (int(timer.time_left * 1000) % 1000)
		else:
			if !timer_count_up:
				timer_text.text = "[center]%d" % timer.wait_time
				secondary_timer_text.text = "[center]%03d" % (int(timer.wait_time * 1000) % 1000)
	if Input.is_action_just_pressed("back"):
		game_over()



func _physics_process(delta: float) -> void:
	var origin_rot = Quaternion(origin.transform.basis)
	if origin_rot != proxy_tilt:
		var slerp = origin_rot.slerp(proxy_tilt, 0.1)
		origin.transform.basis = Basis(slerp)

	if marble != null:
		marble.apply_force(Vector3(input_tilt.x / 3, 2, input_tilt.y / 3) * delta * 3000)

func place_control() -> void:
	
	name_text.set_size(get_window().get_size())
	name_text.set_position(Vector2(0, get_window().get_size().y / 40))
	name_text.add_theme_font_size_override("normal_font_size", 20 * get_window().get_size().x / 1280)
	
	timer_text.set_size(get_window().get_size())
	timer_text.set_position(Vector2(0, get_window().get_size().y / 20))
	timer_text.add_theme_font_size_override("normal_font_size", 35 * get_window().get_size().x / 1280)
	
	secondary_timer_text.set_size(get_window().get_size())
	secondary_timer_text.set_position(Vector2(0, timer_text.get_theme_font_size("normal_font_size") * 6 / 7))
	secondary_timer_text.add_theme_font_size_override("normal_font_size", 18 * get_window().get_size().x / 1280)
	
	timer_text.visible = false
	

func start_game() -> void:
	transitioning = true
	allow_input = false
	UI.visible = true
	
	var holder = preload("res://Main/Player.tscn").instantiate()
	holder.set_customization(PlayerInfo.player_data.player_customization)
	marble = holder
	add_child(marble)
	marble.next_level.connect(next_level)
	marble.orientation_change.connect(reset_orientation)
	
	if is_run:
		run_handler.reset_run()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	set_time()
	
	if instanced != null:
		instanced.queue_free()
	
	level_handler.generate_level(false)
	
	run_handler.inRun = true
	
	marble.reset()

func next_level() -> void:
	transitioning = true
	allow_input = false
	
	camera.next_level()

	marble.visible = false
	prev_instance = instanced
	set_time()
	
	run_handler.next_level()
	
	level_handler.generate_level(true)


	await get_tree().create_timer(0.91).timeout
	
	marble.reset()

func game_over() -> void:
	if is_run and Global.main_scene.popup_scene == null:
		if allow_timer:
			if !timer.is_stopped():
				timer.stop()
		
		run_handler.inRun = false
		allow_input = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		UI.visible = false
		marble.queue_free()
		marble = null
		
		PlayerInfo.player_data.game_over_count += 1
		
		Global.open_popup("run_end")
	else:
		prev_scene()

func set_time() -> void:
	if allow_timer:
		timer_text.visible = true
		if run_handler.inRun:
			if !timer_count_up:
				var remaining_time = timer.time_left
				timer.stop()
				var tween = create_tween()
				tween.tween_method(timer.set_wait_time, remaining_time, remaining_time + 3, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		else:
			if timer_count_up:
				time_taken = 0.0
			timer.stop()
			timer.set_wait_time(20)
			timer_text.text = "[center]%d" % 20
			secondary_timer_text.text = "[center]%03d" % 0

func start_timer():
	timer.start()
	transitioning = false

func default_camera_skybox() -> void:
	match level_type:
		0:
			camera.allow_input = true
			var rot = randf_range(0, 360)
			camera.rotation.y = deg_to_rad(rot)
			var tween = create_tween()
			tween.tween_property($camera_y/Camera3D, "position", Vector3(0,5 + 1.5 * (level_handler.current_level.camera_pos / 16.5), level_handler.current_level.camera_pos), 0.1)
		1:
			camera.allow_input = false
			match randi_range(0,1):
				0:
					camera.rotation.y = deg_to_rad(90)
				1:
					camera.rotation.y = deg_to_rad(-90)

func reset_orientation() -> void:
	allow_input = false
	if level_type == 0:
		camera.rand_rotation()

func level_generated(level_info : level_resource) -> void:
	name_text.text = "[center]" + level_info.name
	level_type = level_info.level_type
	default_camera_skybox()
	instanced.start_level()
	marble.reset_pos = instanced.choose_spawn()
	
func prev_scene() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.close_popup()
	Global.open_scene(Global.main_scene.prev_scene)
	
