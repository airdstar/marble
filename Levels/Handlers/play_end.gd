extends Node

var scoreHolder : int

func _ready():
	
	if RunInfo.current_level > PlayerInfo.player_data.highest_level:
		PlayerInfo.player_data.highest_level = RunInfo.current_level
	Global.runBase.timerText.visible = false
	
	PlayerInfo.save_info()
	
	get_tree().paused = true
	RunInfo.inRun = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		get_tree().paused = false
		Global.main.main_menu()

func run_restart() -> void:
	get_tree().paused = false
	Global.runBase.timerText.visible = true
	Global.runBase.start_game()
	queue_free()
