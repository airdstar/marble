extends Node

@onready var level_display = $CenterContainer/VBoxContainer/points

func _ready():
	level_display.text = "[center][rainbow]"
	if RunInfo.current_level > PlayerInfo.player_data.highest_level:
		level_display.text += "New Record!\n"
		PlayerInfo.player_data.highest_level = RunInfo.current_level
	Global.runBase.timerText.visible = false
	level_display.text += "You reached level %d!" % RunInfo.current_level
	PlayerInfo.save_data()
	
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
