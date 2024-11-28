extends Node

enum difficulty {
	EASY,
	MEDIUM,
	HARD,
	TEST
}

var currentDifficulty : difficulty = difficulty.EASY
var playerColor : Color = Color(0.227,1,0.51)

var inRun : bool = false
var clearedLevels : int = 0
var points_earned : int = 0
