extends Node

enum difficulty {
	EASY,
	MEDIUM,
	HARD
}

var inRun := false

var current_difficulty : difficulty
var current_level := 1
var levels_until_change := 5

signal difficulty_changed

func reset_run() -> void:
	levels_until_change = 5
	current_level = 1
	current_difficulty = difficulty.EASY
	difficulty_changed.emit(Global.easy_levels)

func next_level() -> void:
	current_level += 1
	levels_until_change -= 1
	if levels_until_change == 0:
		change_difficulty()


func change_difficulty() -> void:
	match current_difficulty:
		difficulty.EASY:
			current_difficulty = difficulty.MEDIUM
			levels_until_change = 2
			difficulty_changed.emit(Global.medium_levels)
		difficulty.MEDIUM:
			current_difficulty = difficulty.EASY
			levels_until_change = 5
			difficulty_changed.emit(Global.easy_levels)
