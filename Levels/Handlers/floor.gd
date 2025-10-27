extends Node3D
class_name Floor

#Floor Settings
var is_run := false
var test := false
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
var instanced_level : level


var difficulty : FloorLevel.difficulty
var difficulty_change := 5

var level_num := 1
var current : level_resource
var pool : Array[level_resource]

var playing := false

var timer_paused := true
var remaining_time := 20.0
var elapsed_time := 0.0

@onready var origin := $Origin

func _ready() -> void:
	%Player.set_customization(Data.data.player_customization)
	
	if Data.settings.speed_display:
		%FPSLabel.show()
	if Data.settings.fps_display:
		%SpeedLabel.show()

func _process(delta: float) -> void:
	%FPSLabel.text = "%d FPS" % Engine.get_frames_per_second()
	%SpeedLabel.text = "%.2f" % (abs(%Player.angular_velocity.length()))
	
	if allow_input:
		var input = Input.get_last_mouse_velocity()
		var tilt_transform = %Camera.transform.basis * Vector3(input.x, 0, input.y)
		input = Vector2(tilt_transform.x, tilt_transform.z)
		var prev_input = input_tilt
		if input.y > Data.settings.tilt_deadzone or input.y < -Data.settings.tilt_deadzone:
			input_tilt.x += input.y * Data.settings.tilt_sens * 0.001 * delta
			input_tilt.x = clamp(input_tilt.x, deg_to_rad(-15), deg_to_rad(15))
		if input.x > Data.settings.tilt_deadzone or input.x < -Data.settings.tilt_deadzone:
			input_tilt.y += -input.x * Data.settings.tilt_sens * 0.001 * delta
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
	
	if !timer_paused:
		remaining_time -= delta
		elapsed_time += delta
		if remaining_time <= 0:
			game_over()
	
	%Seconds.text = "%d" % remaining_time
	%Milliseconds.text = "%03d" % (int(remaining_time * 1000) % 1000)

	if Input.is_action_just_pressed("back"):
		if !Game.popup:
			Game.close_popup()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Game.open_scene("res://Main/Menus/MainMenu.tscn")
		else:
			game_over()

func _physics_process(delta: float) -> void:
	var origin_rot = Quaternion(origin.transform.basis)
	if origin_rot != proxy_tilt:
		var slerp = origin_rot.slerp(proxy_tilt, 0.1)
		origin.transform.basis = Basis(slerp)

	%Player.apply_force(Vector3(input_tilt.x / 3, 2, input_tilt.y / 3) * delta * 3000)

func start_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	transitioning = true
	allow_input = false
	
	%Gameover.hide()
	%Timer.show()
	
	level_num = 1
	timer_paused = true
	elapsed_time = 0
	remaining_time = 20
	
	if is_run:
		difficulty = FloorLevel.difficulty.EASY
		difficulty_change = 5
		pool = Data.get_in_pool_levels(difficulty)
	load_level(false)
	
	playing = true
	%Player.reset()

func next_level() -> void:
	transitioning = true
	allow_input = false
	
	level_num += 1
	timer_paused = true
	elapsed_time = 0
	var tween = create_tween()
	tween.tween_property(self, "remaining_time", remaining_time + 3, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	
	%Camera.next_level()
	
	if is_run:
		difficulty_change -= 1
		if difficulty_change == 0:
			adjust_difficulty()
	load_level()
	
	await get_tree().create_timer(0.91).timeout
	%Player.reset()

func load_level(delay := true) -> void:
	var chosen
	if !in_order:
		chosen = pool.pick_random()
		while chosen == current:
			chosen = pool.pick_random()
	else:
		chosen = pool[level_num]
	if delay:
		await get_tree().create_timer(0.4).timeout
	if instanced_level != null:
		instanced_level.queue_free()
	current = chosen
	instanced_level = current.associated_scene.instantiate()
	origin.add_child(instanced_level)
	
	%LevelNum.text = str(level_num)
	%NameLabel.text = current.name
	
	level_type = current.level_type
	default_camera_skybox()
	instanced_level.start_level()
	%Player.reset_pos = instanced_level.choose_spawn()

func adjust_difficulty() -> void:
	match difficulty:
		FloorLevel.difficulty.EASY:
			difficulty = FloorLevel.difficulty.MEDIUM
			difficulty_change = 2
		FloorLevel.difficulty.MEDIUM:
			difficulty = FloorLevel.difficulty.EASY
			difficulty_change = 5
	pool = Data.get_in_pool_levels(difficulty)

func game_over() -> void:
	timer_paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if is_run:
		%Player.hide()
		%Player.disable_collision()
		playing = false
		allow_input = false
		
		%Timer.hide()
		
		%Gameover.show()
		
		
	else:
		Game.open_scene("res://Main/Menus/MainMenu.tscn")

func start_timer():
	timer_paused = false
	transitioning = false

func default_camera_skybox() -> void:
	match level_type:
		0:
			%Camera.allow_input = true
			var rot = randf_range(0, 360)
			%Camera.rotation.y = deg_to_rad(rot)
			var tween = create_tween()
			tween.tween_property(%Camera.camera, "position", Vector3(0,5 + 1.5 * (current.camera_pos / 16.5), current.camera_pos), 0.1)
		1:
			%Camera.allow_input = false
			match randi_range(0,1):
				0:
					%Camera.rotation.y = deg_to_rad(90)
				1:
					%Camera.rotation.y = deg_to_rad(-90)

func reset_orientation() -> void:
	allow_input = false
	if level_type == 0:
		%Camera.rand_rotation()
