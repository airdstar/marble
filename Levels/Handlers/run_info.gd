extends Node
class_name RunInfo

enum difficulty {
	EASY,
	MEDIUM,
	HARD,
	TEST
}

var inRun : bool = false

var current_difficulty : difficulty
var current_level : int = 1
var levels_until_change : int = 5

func change_difficulty():
	match current_difficulty:
		difficulty.EASY:
			current_difficulty = difficulty.MEDIUM
			levels_until_change = 2
		difficulty.MEDIUM:
			current_difficulty = difficulty.EASY
			levels_until_change = 5
