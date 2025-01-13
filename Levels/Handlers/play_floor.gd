extends floor
class_name play_floor

@onready var timer = $RemainingTime
@onready var timerText = $Control/Timer
@onready var run_info : RunInfo = $RunInfo

func place_control() -> void:
	timerText.set_size(get_window().get_size())
	timerText.set_position(Vector2(0, get_window().get_size().y / 20))


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
