extends Node
class_name RunHandler

var inRun := false

var current_difficulty : FloorLevel.difficulty
var current_level := 1
var levels_until_change := 5

signal difficulty_changed

func reset_run() -> void:
	levels_until_change = 5
	current_level = 1
	current_difficulty = FloorLevel.difficulty.EASY
	difficulty_changed.emit(easy_levels)

func next_level() -> void:
	current_level += 1
	if !master.set_pool:
		levels_until_change -= 1
		if levels_until_change == 0:
			change_difficulty()


func change_difficulty() -> void:
	match current_difficulty:
		FloorLevel.difficulty.EASY:
			current_difficulty = FloorLevel.difficulty.MEDIUM
			levels_until_change = 2
			difficulty_changed.emit(medium_levels)
		FloorLevel.difficulty.MEDIUM:
			current_difficulty = FloorLevel.difficulty.EASY
			levels_until_change = 5
			difficulty_changed.emit(easy_levels)
