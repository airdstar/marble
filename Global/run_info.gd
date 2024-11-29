extends Node

enum difficulty {
	EASY,
	MEDIUM,
	HARD,
	TEST
}

var inRun : bool = false

var currentDifficulty : difficulty = difficulty.EASY

var clearedLevels : int = 0
var points_earned : int = 0
