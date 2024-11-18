extends Node

func _ready():
	$ColorPickerButton.color = RunInfo.playerColor

func color_changed(color: Color) -> void:
	RunInfo.playerColor = color

func easy_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.EASY
	get_parent().start_run()

func medium_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.MEDIUM
	get_parent().start_run()

func hard_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.HARD
	get_parent().start_run()

func test_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.TEST
	get_parent().start_run()
