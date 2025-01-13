extends floor
class_name play_floor

@onready var timer = $RemainingTime
@onready var timerText = $Control/Timer
@onready var run_info : RunInfo = $RunInfo

func place_control() -> void:
	timerText.set_size(get_window().get_size())
	timerText.set_position(Vector2(0, get_window().get_size().y / 20))


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
