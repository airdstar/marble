extends floor
class_name play_floor

@onready var timer = $RemainingTime
@onready var timerText = $Control/Timer
@onready var run_info : RunInfo = $RunInfo

func secondary_process() -> void:
	if !transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	else:
		timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	if Input.is_action_just_pressed("back"):
		game_over()

func place_control() -> void:
	timerText.set_size(get_window().get_size())
	timerText.set_position(Vector2(0, get_window().get_size().y / 10))


func start_game() -> void:
	transitioning = true
	allow_input = false
	run_info.levels_until_change = 5
	run_info.current_level = 1
	run_info.current_difficulty = run_info.difficulty.EASY

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if instanced != null:
		instanced.queue_free()
	
	create_level()
	set_level_data()
	change_skybox_rotation()
	run_info.inRun = true
	
	if marble == null:
		var holder = preload("res://Main/Marble.tscn").instantiate()
		add_child(holder)
		marble = holder
	
	call_deferred("reset_marble")

func next_level() -> void:
	run_info.current_level += 1
	run_info.levels_until_change -= 1
	if run_info.levels_until_change == 0:
		run_info.change_difficulty()
	
	transitioning = true
	prev_instance = instanced
	marble.visible = false
	
	create_level()
	set_level_data()
	camera.next_level()
	change_skybox_rotation()
	
	await get_tree().create_timer(0.3).timeout
	allow_input = false
	
	await get_tree().create_timer(0.61).timeout
	
	reset_marble()

func set_level_data() -> void:
	tagline_text.text = level_info.tagline
	
	set_level_time()
	
	if run_info.inRun:
		await get_tree().create_timer(0.3).timeout
		prev_instance.queue_free()
	
	default_camera_skybox()
	
	origin.add_child(instanced)
	instanced.start_level()

func set_level_time():
	if run_info.inRun:
		var remaining_time = timer.time_left
		timer.stop()
		var tween = create_tween()
		tween.tween_method(timer.set_wait_time, remaining_time, remaining_time + 4.5, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	else:
		timer.stop()
		timer.set_wait_time(20)

func pick_level() -> void:
	var valid_level := false
	while !valid_level:
		match run_info.current_difficulty:
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

func start_timer():
	timer.start()
	transitioning = false

func game_over() -> void:
	if !timer.is_stopped():
		timer.stop()
	var overlay = preload("res://Levels/Handlers/PlayEnd.tscn").instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(overlay)

func time_up() -> void:
	game_over()
