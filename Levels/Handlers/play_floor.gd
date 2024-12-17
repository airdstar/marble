extends floor
class_name play_floor

@onready var timer = $RemainingTime
@onready var timerText = $CanvasLayer/Timer

func secondary_process() -> void:
	if !transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	else:
		timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	if Input.is_action_just_pressed("back"):
		game_over()

func next_level() -> void:
	RunInfo.current_level += 1
	RunInfo.levels_until_change -= 1
	if RunInfo.levels_until_change == 0:
		RunInfo.change_difficulty()
	
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
	if RunInfo.inRun:
		var remaining_time = timer.time_left
		timer.stop()
		var tween = create_tween()
		tween.tween_method(timer.set_wait_time, remaining_time, remaining_time + level_info.given_time, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
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
