extends Node

var scoreHolder : int

func _ready():
	PlayerInfo.save_info()
	scoreHolder = RunInfo.clearedLevels
	RunInfo.clearedLevels = 0
	Global.runBase.points.text = "[center]" + str(RunInfo.clearedLevels)
	Global.runBase.points.visible = false
	Global.runBase.timerText.visible = false
	$points.text = "[rainbow]You cleared " + str(scoreHolder) + " levels"
	
	get_tree().paused = true
	RunInfo.inRun = false

func run_restart() -> void:
	get_tree().paused = false
	Global.runBase.timerText.visible = true
	Global.runBase.points.visible = true
	Global.runBase.start_game()
	queue_free()
