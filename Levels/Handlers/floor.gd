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
var chosenSpawn : Vector2

#Player related
var settings = PlayerInfo.player_settings

@onready var camera := $camera_y
@onready var origin := $Origin
@onready var timer : Timer = $Timer

@onready var level_handler : LevelHandler = $LevelHandler
@onready var run_handler : RunHandler = $RunHandler

@onready var timer_text = $UI/Timer
@onready var name_text = $UI/VBoxContainer/name
@onready var fps_text = $UI/VBoxContainer/fps
@onready var speed_text = $UI/VBoxContainer/speed

func _ready() -> void:
	place_control()

func _process(delta: float) -> void:
	
	fps_text.text = "FPS %d" % Engine.get_frames_per_second()
	speed_text.text = "Speed %.2f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
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
			timer_text.text = "[center]" + "%.2f" % timer.time_left
		else:
			timer_text.text = "[center]" + "%.2f" % timer.wait_time
	
	
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
	
	timer_text.set_size(get_window().get_size())
	timer_text.set_position(Vector2(0, get_window().get_size().y / 20))
	
	timer_text.visible = false
	

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
	
	run_handler.inRun = true
	
	if marble == null:
		var holder = preload("res://Main/Player.tscn").instantiate()
		holder.set_customization(PlayerInfo.player_data.player_customization)
		add_child(holder)
		marble = holder
	
	call_deferred("reset_marble")

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
	
	reset_marble()

func game_over() -> void:
	if is_run and Global.main_scene.popup_scene == null:
		if allow_timer:
			if !timer.is_stopped():
				timer.stop()
		
		run_handler.inRun = false
		allow_input = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		timer_text.visible = false
		marble.visible = false
		marble.collision.set_deferred("monitorable", false)
		
		PlayerInfo.player_data.game_over_count += 1
		
		Global.open_popup("run_end")
	else:
		prev_scene()


func set_time() -> void:
	if allow_timer:
		timer_text.visible = true
		if run_handler.inRun:
			var remaining_time = timer.time_left
			timer.stop()
			var tween = create_tween()
			tween.tween_method(timer.set_wait_time, remaining_time, remaining_time + 3, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		else:
			timer.stop()
			timer.set_wait_time(20)

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

func reset_marble() -> void:
	marble.visible = true
	marble.linear_velocity = Vector3.ZERO
	marble.angular_velocity = Vector3.ZERO
	marble.position = Vector3(chosenSpawn.x,20,chosenSpawn.y)
	marble.enable_monitoring()

func reset_orientation() -> void:
	allow_input = false
	if level_type == 0:
		camera.rand_rotation()

func killzone_touched(_area: Area3D) -> void:
	reset_marble()
	reset_orientation()

func level_generated(level_info : level_resource) -> void:
	name_text.text = level_info.name
	level_type = level_info.level_type
	default_camera_skybox()
	
	instanced.start_level()
	
func prev_scene() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.close_popup()
	Global.open_scene(Global.main_scene.prev_scene)
	
