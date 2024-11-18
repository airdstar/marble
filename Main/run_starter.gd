extends Node

func _ready():
	$ColorPickerButton.color = RunInfo.playerColor

func color_changed(color: Color) -> void:
	RunInfo.playerColor = color

func easy_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.EASY
	Global.main.start_run()

func medium_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.MEDIUM
	Global.main.start_run()

func hard_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.HARD
	Global.main.start_run()

func test_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.TEST
	Global.main.start_run()
