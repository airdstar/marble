extends floor
class_name play_floor

@onready var timer = $RemainingTime
@onready var timerText = $CanvasLayer/Timer
@onready var points = $CanvasLayer/Points

func secondary_process() -> void:
	if !transitioning:
		timerText.text = "[center]" + "%.1f" % timer.time_left
	else:
		timerText.text = "[center]" + "%.1f" % timer.wait_time
	
	if Input.is_action_just_pressed("reset"):
		game_over()

func set_level_time():
	if RunInfo.inRun:
		var tween = create_tween()
		tween.tween_method(timer.set_wait_time, timer.time_left, timer.time_left + level_info.given_time, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	else:
		timer.set_wait_time(20)
	
	timer.stop()

func start_timer():
	timer.start()
	transitioning = false

func game_over() -> void:
	if !timer.is_stopped():
		timer.stop()
	var overlay = preload("res://Main/RunEnd.tscn").instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(overlay)

func time_up() -> void:
	game_over()
