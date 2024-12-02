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
