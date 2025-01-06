extends floor
class_name play_floor

@onready var timer = $RemainingTime
@onready var timerText = $CanvasLayer/Timer
@onready var run_info : RunInfo = $RunInfo

func secondary_process() -> void:
	if !transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	else:
		timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	if Input.is_action_just_pressed("back"):
		game_over()


func start_game() -> void:
	transitioning = true
	allow_input = false
	run_info.levels_until_change = 5
	run_info.current_level = 1
	if run_info.current_difficulty != RunInfo.difficulty.TEST:
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

func set_level_time():
	if run_info.inRun:
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

func game_over() -> void:
	if !timer.is_stopped():
		timer.stop()
	var overlay = preload("res://Levels/Handlers/PlayEnd.tscn").instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(overlay)

func time_up() -> void:
	game_over()
