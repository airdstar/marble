extends Node3D
class_name floor

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
var level_info : level_resource
var instanced : level
var prev_instance : level
var marble : player
var chosenSpawn : Vector2

#Player related
var settings = PlayerInfo.player_settings

@onready var camera = $camera_y
@onready var origin = $Origin
@onready var skybox = $WorldEnvironment.environment

@onready var name_text = $Control/VBoxContainer/name
@onready var fps_text = $Control/VBoxContainer/fps
@onready var speed_text = $Control/VBoxContainer/speed

func _ready() -> void:
	Global.runBase = self
	camera.skybox = skybox
	place_control()
	start_game()

func _process(delta: float) -> void:
	fps_text.text = "FPS %d" % Engine.get_frames_per_second()
	speed_text.text = "Speed %.01f" % (abs(marble.angular_velocity.x) + abs(marble.angular_velocity.y) + abs(marble.angular_velocity.z))
	
	if allow_input:
		handle_tilt(delta)
	else:
		input_tilt = Vector2.ZERO
	
	secondary_process()

func secondary_process() -> void:
	pass

func _physics_process(_delta: float) -> void:
	
	relative_skybox_rotation += relative_desired_rotation
	skybox.sky_rotation += relative_desired_rotation
	
	input_tilt.x = clamp(input_tilt.x * settings.invert_tilt_x, deg_to_rad(-level_info.max_tilt), deg_to_rad(level_info.max_tilt))
	input_tilt.y = clamp(input_tilt.y * settings.invert_tilt_y, deg_to_rad(-level_info.max_tilt), deg_to_rad(level_info.max_tilt))
	
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
	pass


func start_game() -> void:
	pass

func next_level() -> void:
	pass

func set_level_data() -> void:
	pass

func set_level_time():
	pass

func start_timer():
	pass

func pick_level() -> void:
	pass

func create_level() -> void:
	pick_level()
	instanced = level_info.associated_scene.instantiate()

func default_camera_skybox() -> void:
	match level_info.level_type:
		0:
			camera.allow_input = true
			var rot = randf_range(level_info.possible_rotations.x,level_info.possible_rotations.y)
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
	if level_info.level_type == 0:
		camera.rand_rotation(level_info.possible_rotations.x, level_info.possible_rotations.y)

func change_skybox_rotation() -> void:
	relative_desired_rotation = Vector3(randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003),randf_range(-0.0003,0.0003))

func killzone_touched(_area: Area3D) -> void:
	reset_marble()
	reset_orientation()
