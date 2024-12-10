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
var level_info : level_resource
var instanced : level
var prev_instance : level
var marble : player
var chosenSpawn : Vector2

@onready var camera = $camera_y
@onready var origin = $Origin
@onready var skybox = $WorldEnvironment.environment

func _ready() -> void:
	Global.runBase = self
	camera.skybox = skybox
	start_game()

func _process(delta: float) -> void:
	$CanvasLayer/fps.text = "FPS %d" % Engine.get_frames_per_second()
	$CanvasLayer/speed.text = "Speed %.01f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
	if allowInput:
		handle_tilt(delta)
	else:
		input_tilt = Vector2.ZERO
	
	secondary_process()

func secondary_process() -> void:
	pass

func _physics_process(_delta: float) -> void:
	
	relative_skybox_rotation += relative_desired_rotation
	skybox.sky_rotation += relative_desired_rotation
	
	input_tilt.x = clamp(input_tilt.x, deg_to_rad(-level_info.max_tilt), deg_to_rad(level_info.max_tilt))
	input_tilt.y = clamp(input_tilt.y, deg_to_rad(-level_info.max_tilt), deg_to_rad(level_info.max_tilt))
	
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


func start_game() -> void:
	transitioning = true
	allowInput = false
	RunInfo.current_level = 1
	RunInfo.current_difficulty = RunInfo.difficulty.EASY

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if instanced != null:
		instanced.queue_free()
	
	create_level()
	set_level_data()
	change_skybox_rotation()
	RunInfo.inRun = true
	
	if marble == null:
		var holder = preload("res://Main/Marble.tscn").instantiate()
		add_child(holder)
		marble = holder
	
	call_deferred("reset_marble")
	
	await get_tree().create_timer(0.5).timeout
	allowInput = true

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
	
	await get_tree().create_timer(0.5).timeout
	allowInput = true

func set_level_data() -> void:
	$CanvasLayer/tagline.text = level_info.tagline
	
	set_level_time()
	
	if RunInfo.inRun:
		await get_tree().create_timer(0.3).timeout
		prev_instance.queue_free()
	
	var rot = randf_range(level_info.possible_rotations.x,level_info.possible_rotations.y)
	camera.rotation.y = deg_to_rad(rot)
	camera.skybox.sky_rotation = Vector3(0, deg_to_rad(rot), 0) + relative_skybox_rotation
	
	origin.add_child(instanced)

func set_level_time():
	pass

func start_timer():
	pass

func pick_level() -> void:
	var valid_level := false
	while !valid_level:
		match RunInfo.current_difficulty:
			0:
				level_info = Global.easy_levels.pick_random()
			1:
				level_info = Global.medium_levels.pick_random()
			2:
				level_info = Global.hard_levels.pick_random()
		
		if !level_info.needs_testing:
			valid_level = true
	
	var id : String = level_info.resource_path.trim_prefix("res://Levels/Info/")
	if '.tres.remap' in id:
		id = id.trim_suffix('.tres.remap')
	else:
		id = id.trim_suffix('.tres')
	
	if !PlayerInfo.player_data.visited_levels.has(int(id)):
		PlayerInfo.player_data.visited_levels.append(int(id))

func create_level() -> void:
	pick_level()
	instanced = level_info.associated_scene.instantiate()

func reset_marble() -> void:
	marble.visible = true
	marble.linear_velocity = Vector3.ZERO
	marble.angular_velocity = Vector3.ZERO
	marble.position = Vector3(chosenSpawn.x,15,chosenSpawn.y)

func reset_orientation() -> void:
	allowInput = false

	camera.rand_rotation(level_info.possible_rotations.x, level_info.possible_rotations.y)
	
	await get_tree().create_timer(0.7).timeout
	allowInput = true

func change_skybox_rotation() -> void:
	relative_desired_rotation = Vector3(randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003))

func killzone_touched(_area: Area3D) -> void:
	reset_marble()
	reset_orientation()
